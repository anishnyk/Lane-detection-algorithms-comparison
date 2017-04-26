#include <opencv2\core.hpp>
#include <opencv2\imgproc.hpp>
#include <opencv2\opencv.hpp>

using namespace cv;
using namespace std;

int main(int argc, char* argv[])
{
	Mat source;
	source = imread("../Assets/RoadMarkingDataset/roadmark_0001.jpg", CV_LOAD_IMAGE_GRAYSCALE);

	if (source.empty())
	{
		// Source image empty: Check image path
		cout << "Invalid path" << endl;
		system("pause");
		return -1;

	}
	else
	{
		// Source image imported: Display image
		namedWindow("Source image", CV_WINDOW_AUTOSIZE);
		imshow("Source image", source);
		waitKey(0);

		// Thresholding algorithm


		return 0;
	}
}