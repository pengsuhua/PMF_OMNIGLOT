# import os
# import cv2
#
#
# input_folder = r"D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise\chinese_character_10(PMF)\run1\test_1"  # 输入数据文件夹路径 # for PMF_master code
# output_folder = r"D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise\chinese_character_10(PMF)\run1\output_detection_noise_10_test"  # 输出结果文件夹路径 # for PMF_master code
#
# grid_size = (5, 5)  # 网格大小
# line_color = (255, 255, 255)  # 网格线颜色
#
# # 遍历输入文件夹下的所有文件夹
# for root, dirs, files in os.walk(input_folder):
#     for dir_name in dirs:
#         input_dir = os.path.join(root, dir_name)  # 输入子文件夹路径
#         output_dir = os.path.join(output_folder, dir_name)  # 输出子文件夹路径
#         os.makedirs(output_dir, exist_ok=True)  # 创建对应的输出子文件夹
#
#         # 遍历子文件夹下的图像文件
#         for file_name in os.listdir(input_dir):
#             if file_name.endswith(".bmp"):
#                 input_image_path = os.path.join(input_dir, file_name)  # 输入图像路径
#                 output_image_path = os.path.join(output_dir, file_name)  # 输出图像路径
#
#                 # 加载图像
#                 image = cv2.imread(input_image_path)
#
#                 # 计算每个格子的大小
#                 cell_width = image.shape[1] // grid_size[1]
#                 cell_height = image.shape[0] // grid_size[0]
#
#                 # 绘制垂直线
#                 for x in range(0, image.shape[1]+1, cell_width):
#                     cv2.line(image, (x, 0), (x, image.shape[0]), line_color,thickness=1)  # thickness：控制改变绘制的网格线条的粗细。默认值为1。
#
#                 # 绘制水平线
#                 for y in range(0, image.shape[0]+1, cell_height):
#                     cv2.line(image, (0, y), (image.shape[1], y), line_color,thickness=1)  # thickness：控制改变绘制的网格线条的粗细。默认值为1。
#
#                 # 保存结果
#                 cv2.imwrite(output_image_path, image)




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
    output_folder = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\PMF_one-shot-classification_noise\deletion_noise\67'  # for PMF_matster

    # input_folder = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\images_evaluation_a'  # for PMF_matster
    # output_folder = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\images_evaluation_a_noise\deletion_noise_0'  # for PMF_matster



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

                image = read_image_and_add_lines(file_path, 6, 7, (255, 255, 255))

                # 保存结果
                output_path = os.path.join(output_directory, file)  # 输出图片的路径
                cv2.imwrite(output_path, image)