# Eigenfaces-for-recognition

This project is inspired by an article entitled "Eigenfaces for recognition," written by Turk and Pentland and published in the Journal of Cognitive Neuroscience in 1991.

\textbf{Description of the data}

You have n images of faces from a set of people. Each person is photographed in the same number of facial expressions (frontal, three-quarter view, with three emotions). Each of these n grayscale images is stored in a two-dimensional matrix of size 
$300 \times 400$. These n images constitute the training images. By vectorizing them, you can represent these images as column vectors in $\mathbbR^p$, where $p=300 \times 400 = 12000$ is the number of pixels common to all images.
