# 🧠 Spike Detection using ML - Thesis Pipeline

This repository contains a full EEG analysis pipeline in MATLAB, developed for a thesis project. The pipeline includes raw EEG processing, spike labeling, source waveform projection, feature extraction, and classification using an Artificial Neural Network (ANN).

---

## 📋 Pipeline Overview

1. [Loading EEG Data](#1-loading-eeg-data)  
2. [Creating Epochs](#2-creating-epochs)  
3. [Labeling Epochs](#3-labeling-epochs)  
4. [Preprocessing](#4-preprocessing)  
5. [Grand Averaging](#5-grand-averaging)  
6. [MRI Preprocessing](#6-mri-preprocessing)  
7. [Selecting Nodes](#7-selecting-nodes)  
8. [Source Waveform Projection](#8-source-waveform-projection)  
9. [ANN Function](#9-ann-function)  
10. [ANN Training](#10-ann-training)  
11. [Feature Extraction](#11-feature-extraction)  

---

## ⚙️ Requirements

Make sure the following MATLAB toolboxes are installed:

- Signal Processing Toolbox  
- FieldTrip Toolbox  
- Deep Learning Toolbox  
- Statistics and Machine Learning Toolbox  

---

## 🔧 Step-by-Step Pipeline

### 1. Loading EEG Data
- 📄 [`load_data.m`](scripts/load_data.m): Load raw EEG `.mat` files into memory.
- 📄 [`spike_times.m`](scripts/spike_times.m): Load spike times annotated by three epileptologists.

### 2. Creating Epochs
- 📄 [`create_epochs.m`](scripts/create_epochs.m): Segment EEG into 1-second epochs.

### 3. Labeling Epochs
- 📄 [`labeling.m`](scripts/labeling.m): Assign binary labels to each epoch using spike timing.

### 4. Preprocessing
- 📄 [`preprocessing_function.m`](scripts/preprocessing_function.m): Apply bandpass filtering, etc.
- 📄 [`preprocessing.m`](scripts/preprocessing.m): Preprocess the entire dataset.

### 5. Grand Averaging
- 📄 [`grand_averaging.m`](scripts/grand_averaging.m): Compute ERP averages across subjects or conditions.

### 6. MRI Preprocessing
- 📄 [`mri_preprocessing.m`](scripts/mri_preprocessing.m): Process anatomical MRI for source localization.

### 7. Selecting Nodes
- 📄 [`select_nodes.m`](scripts/select_nodes.m): Choose brain regions or nodes of interest for source analysis.

### 8. Source Waveform Projection
- 📄 [`source_projection.m`](scripts/source_projection.m): Project EEG to source space using inverse modeling.

### 9. ANN Function
- 📄 [`create_ann.m`](functions/create_ann.m): Define neural network structure using MATLAB’s Deep Learning Toolbox.

### 10. ANN Training
- 📄 [`train_ann.m`](scripts/train_ann.m): Train the ANN on extracted features with labeled data.

### 11. Feature Extraction
- 📄 [`feature_extraction.m`](scripts/feature_extraction.m): Extract features such as band power or time-domain stats.

