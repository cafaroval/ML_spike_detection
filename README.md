# 🧠 Spike detection using ML - Thesis Pipeline

This repository contains a full EEG analysis pipeline in MATLAB, developed for a thesis project. The pipeline includes raw EEG processing, source localization, feature extraction, and classification using an Artificial Neural Network (ANN).

---

## 📋 Pipeline Overview

1. Loading EEG Data
2. Creating Epochs
3. Labeling Epochs
4. Preprocessing
5. Grand Averaging
6. MRI Preprocessing
7. Selecting Nodes
8. Source Waveform Projection
9. ANN Training
10. Feature Extraction

---

## ⚙️ Requirements

Please make sure the following MATLAB toolboxes are installed:

- Signal Processing Toolbox
- FieldTrip Toolbox
- Deep Learning Toolbox
- Statistics and Machine Learning Toolbox

---

## 🔧 Step-by-Step Pipeline

### 1. Loading EEG Data
- **Script**: `scripts/load_data.m`
- Load raw EEG files using custom format readers.
- **Script**: `scripts/spike_times.m`
- Load spike times files which was marked by three epileptologists using custom format readers.

### 2. Creating Epochs
- **Script**: `scripts/create_epochs.m`
- Epoch EEG data around relevant event markers.

### 3. Labeling Epochs
- **Script**: `scripts/labeling.m`
- Assign labels to each trial based on conditions or event types.

### 4. Preprocessing
- **Script**: `scripts/preprocessing_function.m`
- Perform filtering.
- **Script**: `scripts/preprocessing.m`

### 5. Grand Averaging
- **Script**: `scripts/grand_averaging.m`
- Compute average ERPs or evoked responses across subjects/conditions.

### 6. MRI Preprocessing
- **Script**: `scripts/mri_preprocessing.m`
- Prepare structural MRI data for source localization.

### 7. Selecting Nodes
- **Script**: `scripts/select_nodes.m`
- Choose specific brain regions or sources for projection and analysis.

### 8. Source Waveform Projection
- **Script**: `scripts/source_projection.m`
- Use inverse modeling to project EEG data into source space.

### 9. ANN Function
- **Script**: `functions/create_ann.m`
- Define ANN architecture using MATLAB’s Deep Learning Toolbox.

### 10. ANN Training
- **Script**: `scripts/train_ann.m`
- Train ANN on extracted features and save the trained model.

### 11. Feature Extraction
- **Script**: `scripts/feature_extraction.m`
- Extract features such as mean amplitude, band power, or latency for classification.


