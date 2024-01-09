import os
import random
from typing import Tuple
import cv2
import numpy as np


def draw_line(img, line_position: int, line_color: Tuple[int, int, int], line_thickness: int, horizontal: bool) -> None:
    """
    :param img: 要添加线条的图像
    :param line_position: 线条的位置
    :param line_color: 线条的颜色，用元组 (r, g, b)表示，其中 r 代表红色，g 代表绿色，b 代表蓝色
    :param line_thickness: 线条的厚度
    :param horizontal: 是否为水平线
    """
    if horizontal:
        cv2.line(img, (0, line_position), (img.shape[1], line_position), line_color, line_thickness)
    else:
        cv2.line(img, (line_position, 0), (line_position, img.shape[0]), line_color, line_thickness)


"""def drew_lines(img, line_positions: list, line_colors: list, line_thicknesses: list, horizontals: list) -> None:
    for line_position, line_color, line_thickness, horizontal in zip(line_positions, line_colors, line_thicknesses, horizontals):
        draw_line(line_position, line_color, line_thickness, horizontal)"""

def read_image_and_add_lines(image_path, horizontal_line_number, vertical_line_number, line_color):
    """
    :param image_path:需要修改的图像路径
    :param output_path: 输出的图像路径
    :param horizontal_line_number: 水平线的条数
    :param vertical_line_number: 竖直线的条数
    :param line_color：线的颜色，用元组 (r, g, b)表示，其中 r 代表红色，g 代表绿色，b 代表蓝色
    :return:
    """
    image = cv2.imread(image_path)
    image_size = image.shape[:2]
    for i in range(horizontal_line_number):
        line_position = int(image_size[0]/2 + random.randint(-10, 10)) # 在图片的水平中线附件加线
        line_thickness = random.choice([1, 2])
        draw_line(image, line_position, line_color, line_thickness, True)
    for i in range(vertical_line_number):
        line_position = int(image_size[1]/2 + random.randint(-10, 10))  # 在图片的垂直中线附件加线
        line_thickness = random.choice([1, 2])
        draw_line(image, line_position, line_color, line_thickness, False)
    #cv2.imwrite(output_path, image)

    return image



if __name__ == '__main__':
    # 设置输入路径和输出路径
    input_folder = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\PMF_one-shot-classification_data\test'  # for PMF_matster
    output_folder = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\PMF_one-shot-classification_noise\clutter_noise\89'  # for PMF_matster

    # input_folder = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\images_evaluation_a'  # for PMF_matster
    # output_folder = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\images_evaluation_a_noise\clutter_noise_0'  # for PMF_matster

    # 遍历输入文件夹中的文件夹
    for root, dirs, files in os.walk(input_folder):
        for directory in dirs:
            input_directory = os.path.join(root, directory)  # 输入文件夹的路径
            output_directory = os.path.join(output_folder, directory)  # 输出文件夹的路径

            # 创建对应的输出文件夹
            os.makedirs(output_directory, exist_ok=True)

            # 遍历输入文件夹中的图片文件
            for file in os.listdir(input_directory):
                file_path = os.path.join(input_directory, file)  # 输入图片的路径

                # 读取图片
                #image = cv2.imread(file_path)
                #image = cv2.imread(file_path, cv2.IMREAD_GRAYSCALE)

                image = read_image_and_add_lines(file_path,8,9 , (0, 0, 0))

                # 保存结果
                output_path = os.path.join(output_directory, file)  # 输出图片的路径
                cv2.imwrite(output_path, image)

