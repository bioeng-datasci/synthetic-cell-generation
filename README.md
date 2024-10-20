This project includes MATLAB code for a UI to design and generate synthetic cell images and the corresponding labels. 

To use the code, simply run the ui_start.m file in the MATLAB editor and a UI will appear:

<img src="https://github.com/user-attachments/assets/7db600d4-608d-4987-b7df-d726803729a8" width="500"> 

The parameters can be adjusted on the left hand side of the figure:

<img src="https://github.com/user-attachments/assets/fe11a694-5848-4b52-bf49-365b8b90b88c" width="500">

The description of each callout in the image above are as follows:
1) The cells are generated as elliptical shapes. Use this slider to adjust the range for the major axis.
2) Use this slider to change the number of cells.
3) Use this slider to select the number of images.
4) Toggle to select image size.
5) Toggle to select difficulty.
   * Easy - cells are uniformly spaced with a high, consistent intensity and no noise.
   * Low - cells are randomly spaced with a variable intensity (can be very low).
   * Moderate - cells are randomly spaced with a variable intensity (can be very low). The center of cells may be dark and noise is added to the images.

To view an example of an image generated with the selected paramters, hit the Preview button:

<img src="https://github.com/user-attachments/assets/6223c26a-0bf9-4a92-80d6-4c07e5b0c29e" width="500">

Which will show on the UI:

<img src="https://github.com/user-attachments/assets/1facaa29-572b-4b61-b6db-a7588ad1dd02" width="500">

Once satisfied with your parameter selection, hit the Generate button:

<img src="https://github.com/user-attachments/assets/7e7e3cc1-2bb5-4fc8-b0d2-72924841904b" width="500">

You will be prompted to selected a save folder and the images and labels will be saved in two separate subfolders of your selected directory.

Please note that unrealistic images may be generated based on the parameter selection:

<img src="https://github.com/user-attachments/assets/e3209c49-dc07-42e0-ae66-d7e2b4995c8c" width="500">

The default UI parameters are a good starting place. 

The following figure shows examples of generated images using each of the difficulty levels:

<img src="https://github.com/user-attachments/assets/66a115cd-df3d-47f8-861f-4977a772f5b9" width="600">

Further examples are in the "example_output" zip file.




MATLAB version: 2024b
