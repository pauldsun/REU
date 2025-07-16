import numpy as np
import cv2
import pyrealsense2 as rs
import cv2.aruco as aruco
import os

#print(np.load('calib_rgb.npz'))

with np.load('calib_rgb.npz') as X:
    cameraMatrix, distCoeffs = [X[i] for i in ('cameraMatrix', 'distCoeffs')]

markerLength = 0.013229

objPoints = np.array([
    [-markerLength/2, markerLength/2, 0],
    [markerLength/2, markerLength/2, 0],
    [markerLength/2, -markerLength/2, 0],
    [-markerLength/2, -markerLength/2, 0]
], dtype= np.float32)

arucoDict = aruco.getPredefinedDictionary(aruco.DICT_4X4_100)
parameters = aruco.DetectorParameters()
detector = aruco.ArucoDetector(arucoDict, parameters)

pipeline = rs.pipeline()
config = rs.config()

config.enable_stream(rs.stream.color, 1920, 1080, rs.format.bgr8, 30)
pipeline.start(config)

try:
    while True:
        frames = pipeline.wait_for_frames()
        color_frame = frames.get_color_frame()
        
        if not color_frame:
            continue

        frame = np.asanyarray(color_frame.get_data())
        #cv2.imshow("MarkerDetection", frame)

        h, w = frame.shape[:2]
        newCameraMatrix, roi = cv2.getOptimalNewCameraMatrix(cameraMatrix, distCoeffs, (w,h), 1, (w,h))
        undistorted = cv2.undistort(frame, cameraMatrix, distCoeffs, None, newCameraMatrix)
        #cv2.imshow("Undistorted and ArUco", undistorted)
        gray = cv2.cvtColor(undistorted, cv2.COLOR_BGR2GRAY)

        markerCorners, ids, _ = detector.detectMarkers(gray)

        if ids is not None:
            aruco.drawDetectedMarkers(undistorted, markerCorners, ids)

            for corner in markerCorners:
                success, rvec, tvec = cv2.solvePnP(objPoints, corner[0], newCameraMatrix, distCoeffs)
                cv2.drawFrameAxes(undistorted, newCameraMatrix, distCoeffs, rvec, tvec, markerLength*.5)
        cv2.imshow("MarkerDetection", undistorted)    
        if cv2.waitKey(1) == ord('q'):
            break

finally:
    pipeline.stop()
    cv2.destroyAllWindows()