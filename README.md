# Ultrasound Probe Calibration

## Project Arbeit at MTEC Departmet TUHH

#### Author
1. Nilesh Hampiholi (nilesh.hampiholi@tuhh.de)

#### Project Guide
1. Johanna Sprenger
2. Stefan Gerlach

#### Superviser 
1. Prof. Dr. Alexander Schlaefer

## Abstract 

Ultrasound is utilized as medical imaging technology across multiple clinical diagnostic and therapeutic contexts primarily due to its availability and non-radioactive nature. Although 3D ultrasound probes have become increasingly accessible, most systems still employ 2D probes as they are highly efficient and affordable. Also, the 2D ultrasound images can be used to reconstruct the 3D ultrasound volume. One of the applications of ultrasound is to enable the practitioner to have a 3D visualization of the tissue, like a hologram displayed in real-time as an overlay over the practitioner’s field of view of reality. To accomplish the same, an ultrasound probe is swept across the area of interest, and the trajectory is recorded by the robot. The challenge is that the system records the end-effector pose and not the pose of the scan plane. Through calibration, the transformation matrix is established between the robot end-effector coordinate frame and the ultrasound probe frame. Current ultrasound calibration procedures usually demand freehand motions demanding human intervention, which restricts the application and integration with current robotic systems. This work presents a method for automatic robot-guided ultrasound probe calibration and volume scanning that is also efficient. The proposed method employs a wire phantom with four layers of N-shaped structure stacked one below the other. A UR3 lightweight robot and a Cepasonics ultrasound system are employed to perform the calibration. The overall calibration is accomplished in 500 seconds. An automatic segmentation algorithm identifies the markers with an accuracy of 0.3812 mm and 0.5670 mm in x and z directions. For spatial calibration, a combination of geometric method and iterative closest point algorithm is applied in coordination with a virtual point cloud phantom achieving a mean 3D localization error of 0.7049 mm. Through this procedure, sensor-to-robot calibration is accomplished with a mean translation and rotation error of 4.081 mm and 12.4308°.  Validation of the ultrasound probe calibration is achieved by reconstructing the surface of a 3D printed model phantom using 2D ultrasound images. Results demonstrated that the robot-assisted wire phantom calibration significantly improved the calibration repeatability and shorter data acquisition time.


## Calibration 

To run the calibration clone the repository 

Execute ---> main_US_Caliberation.m

Read the comments in the file to perform a fresh calibration. 


## File structure 

### move_robot

1. Contains config files used to while recording the images. Different config files are used to record data for wire phaantom and part phantom.

2. scan_wire_phantom.m scans moves the robot to 130 unique poses and recordes the images. 

3. scan_part phantom.m scans the part phantom takes about 120 images while moving in a straight line of steps 0.25mm.

4. requires network devices to be in the path.

### raw_data_to_US_image

1. Convet raw images to jpg images for part and wire phantom 

2. For a new calibration create a new folder trial_x. Copy all the raw files in this folder.

### image_segmentation
1. Stores all the jpg images.  

2. Segments all the images.  

3. Extract centiods from the images and stores in a csv files in following format [x y x y x y ....]. 

### create_virtual_phantom

1. creates a virtual phantom either with orign at wire of structure. 

### CAD- Model 
1. Contains 3d model of the wire phantom structure designed in fusion  360.

### registration_icp 

1. Computes trasfromation between the probe frame and wire phantom frame using ICP algorithm. 

2. Stores the transformation in csv file.

### registration_geometry

1. Computes trasfromation between the probe frame and wire phantom frame using geometric method. 

2. Stores the transformation in csv file.

### 3D reconstruction

1. Scans through all the images of the segments them. 

2. From the segments images the high intensity pixels are extracted to generate point clouud.

3. Trasfrom the point cloud using hand eye calibration results. 

### solve_ax_yb
1. Solves hand eye calibration (AX=YB) using QR24 algorithm. 

### robot_poses 

1. Stores all the poses of the robot while recording data. 


### papers

1. Contains all the research papers reffered.

### project_presentation 
1. Contains mid term and final presentation.

### project_report 

1. Contains final report.









