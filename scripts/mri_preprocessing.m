%%=========================================================================
% EEG Forward Model Preparation Script (FieldTrip)
% Description: From MRI to Leadfield with robust practices.
%==========================================================================

%===================== Load MRI ===========================================
mri = ft_read_mri('T1_curry.nii'); % coordinate system scanras

%===================== Realign MRI ========================================
cfg = []; 
cfg.method = 'interactive'; 
cfg.coordsys = 'ctf';
mri_realign = ft_volumerealign(cfg, mri);
% save(fullfile(output_dir, 'mri_realign.mat'), 'mri_realign');

%===================== Reslice MRI ========================================
cfg =[];
cfg.method = 'linear';
cfg.coordsys = 'ctf';
mri_resliced = ft_volumereslice([], mri_realign);
% save(fullfile(output_dir, 'mri_resliced.mat'), 'mri_resliced');

%===================== Plot Slices ========================================
anatomy = mri_resliced.anatomy;
[x_max, y_max, z_max] = size(anatomy);
x = round(x_max/2); y = round(y_max/2); z = round(z_max/2);

figure('Position', [100, 100, 1200, 400]);
subplot(1,3,1); imagesc(flipud(squeeze(anatomy(x,:,:))')); axis image off;
title(sprintf('Coronal (x=%d)', x));
subplot(1,3,2); imagesc(flipud(squeeze(anatomy(:,y,:))')); axis image off;
title(sprintf('Sagittal (y=%d)', y));
subplot(1,3,3); imagesc(flipud(squeeze(anatomy(:,:,z))')); axis image off;
title(sprintf('Axial (z=%d)', z));

%===================== Segment Tissues ====================================
cfg = [];
cfg.output = {'brain', 'skull', 'scalp'};
segment_mri = ft_volumesegment(cfg, mri_resliced);
save(fullfile(output_dir, 'segment_mri.mat'), 'segment_mri');

% Visualize Segmentation
segment_mri_indexed = ft_datatype_segmentation(segment_mri, 'segmentationstyle', 'indexed');
segment_mri_indexed.anatomy = mri_resliced.anatomy;

cfg = [];
cfg.method = 'ortho';
cfg.anaparameter = 'anatomy';
cfg.funparameter = 'tissue';
cfg.funcolormap = gray;
ft_sourceplot(cfg, segment_mri_indexed);

%===================== Create Meshes ======================================
cfg = [];
cfg.tissue = {'brain', 'skull', 'scalp'};
cfg.numvertices = [3000 2000 1000]; 
mesh = ft_prepare_mesh(cfg, segment_mri);
save(fullfile(output_dir, 'mesh.mat'), 'mesh');

%----------------- Check & Flip Normals if Needed -------------------------
for i = 1:numel(mesh)
    v1 = mesh(i).pos(mesh(i).tri(:,2),:) - mesh(i).pos(mesh(i).tri(:,1),:);
    v2 = mesh(i).pos(mesh(i).tri(:,3),:) - mesh(i).pos(mesh(i).tri(:,1),:);
    normals = cross(v1, v2, 2);
    centers = (mesh(i).pos(mesh(i).tri(:,1),:) + mesh(i).pos(mesh(i).tri(:,2),:) + mesh(i).pos(mesh(i).tri(:,3),:))/3;
    mean_dot = mean(dot(normals, centers, 2));
    if mean_dot < 0
        mesh(i).tri = mesh(i).tri(:, [1 3 2]); % Flip if needed
        fprintf('Flipped mesh #%d triangle orientation.\n', i);
    end
end

% Visualize Mesh with Normals
figure; ft_plot_mesh(mesh); hold on; axis equal; camlight; lighting gouraud;

%===================== Prepare Head Model =================================
cfg = [];
cfg.method = 'dipoli'; % Or 'bemcp'
headmodel = ft_prepare_headmodel(cfg, mesh);
save(fullfile(output_dir, 'headmodel.mat'), 'headmodel');

figure;
ft_plot_headmodel(headmodel, 'facecolor','skin','edgecolor','none','facealpha',0.6);
camlight; lighting gouraud; view([0 0]); title('Head Model: BEM');

%===================== Electrode Setup ====================================
elec = ft_read_sens('standard_1020.elc');
desired_labels = {'Fp1','Fp2','F3','F4','C3','C4','P3','P4','O1','O2',...
                  'F7','F8','T3','T4','T5','T6','Fz','Cz','Pz'};
[found, keep] = ismember(desired_labels, elec.label);
keep = keep(keep>0);

selected_elec = elec;
selected_elec.label = elec.label(keep);
selected_elec.elecpos = elec.elecpos(keep,:);
selected_elec.chanpos = elec.chanpos(keep,:);
selected_elec.chantype = elec.chantype(keep,:);
selected_elec.chanunit = elec.chanunit(keep,:);
selected_elec.coordsys = 'ctf';
save(fullfile(output_dir, 'selected_elec.mat'), 'selected_elec');

%===================== Scalp Mesh for Realignment =========================
cfg = [];
cfg.tissue = 'scalp';
cfg.numvertices = 10000;
scalp = ft_prepare_mesh(cfg, segment_mri);

%===================== Electrode Realignment ==============================
cfg = [];
cfg.method = 'interactive'; 
cfg.elec = selected_elec;
cfg.coordsys = 'ctf';
cfg.headshape = scalp;
elec_realigned = ft_electroderealign(cfg);
save(fullfile(output_dir, 'elec_realigned.mat'), 'elec_realigned');

figure; ft_plot_headmodel(headmodel, 'facecolor','skin','edgecolor','none','facealpha',0.6);
hold on; ft_plot_sens(elec_realigned, 'elecshape','sphere', 'facecolor','r', 'label','on');
view([90 0]); camlight; lighting gouraud; title('Head Model with Electrodes');


%===================== Source Model =======================================
cfg = [];
cfg.resolution = 2; % mm grid
cfg.inwardshift = -1; % shrink inside skull
cfg.unit = 'mm';
cfg.headmodel = headmodel;
sourcemodel = ft_prepare_sourcemodel(cfg);
sourcemodel.coordsys = 'ctf';

save sourcemodel.mat sourcemodel

figure; ft_plot_headmodel(headmodel, 'facecolor','cortex','edgecolor','none','facealpha',0.5);
hold on; ft_plot_mesh(sourcemodel.pos(sourcemodel.inside,:), 'vertexcolor','r');
title('3D Source Model Grid'); grid on; view([90 0]);

%===================== Leadfield Computation ==============================
headmodel = ft_convert_units(headmodel, 'mm');
sourcemodel = ft_convert_units(sourcemodel, 'mm');
elec_realigned = ft_convert_units(elec_realigned, 'mm');

cfg = [];
cfg.sourcemodel = sourcemodel;
cfg.elec = elec_realigned;
cfg.headmodel = headmodel;
cfg.reducerank = 3; % EEG
lf = ft_prepare_leadfield(cfg);
save leadfield.mat lf
headmodel.coordsys = 'ctf';
lf.cfg.coordsys = 'ctf';  % assuming `lf` is your leadfield struct

% Visualize Leadfield
figure;
ft_plot_headmodel(headmodel, 'facecolor','cortex','edgecolor','none','facealpha',0.5);
hold on; ft_plot_sens(elec_realigned, 'elecshape','sphere', 'label','on');
ft_plot_mesh(lf.pos(lf.inside,:), 'vertexcolor','b');
title('Leadfield Grid and EEG Electrodes');
grid on; view([90 0]); camlight;
