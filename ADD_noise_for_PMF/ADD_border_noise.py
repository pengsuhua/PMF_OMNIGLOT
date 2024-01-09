from PIL import Image
import os
from PIL import Image, ImageDraw
import cv2
import numpy as np


def image_border(src, dst, width=3, color=(0, 0, 0)):
    '''
    src: (str) 需要加边框的图片路径
    dst: (str) 加边框的图片保存路径
    width: (int) 边框宽度 (默认是3)
    color: (int or 3-tuple) 边框颜色 (默认是0, 表示黑色; 也可以设置为三元组表示RGB颜色)
    '''
    # 读取图片
    img_ori = Image.open(src)
    w = img_ori.size[0]
    h = img_ori.size[1]

    # 创建新的空白图像
    img_new = Image.new('RGB', (w, h), color)

    # 在新图像上绘制原始图像
    img_new.paste(img_ori, (0, 0))

    # 绘制边框
    draw = ImageDraw.Draw(img_new)
    draw.rectangle([(0, 0), (w - 1, width - 1)], fill=color)  # 上边框
    draw.rectangle([(w - width, 0), (w - 1, h - 1)], fill=color)  # 右边框
    #draw.rectangle([(0, h - width), (w - 1, h - 1)], fill=color)  # 下边框
    draw.rectangle([(0, 0), (width - 1, h - 1)], fill=color)  # 左边框

    # 保存图片
    img_new.save(dst)
    return img_new


def process_images(input_dir, output_dir, width=3, color=(0, 0, 0)):
    # 遍历testing文件夹下的文件夹
    for folder_name in os.listdir(input_dir):
        folder_path = os.path.join(input_dir, folder_name)
        if os.path.isdir(folder_path):
            # 创建对应的输出文件夹
            output_folder_path = os.path.join(output_dir, folder_name)
            os.makedirs(output_folder_path, exist_ok=True)

            # 处理文件夹中的图片
            for file_name in os.listdir(folder_path):
                file_path = os.path.join(folder_path, file_name)
                if os.path.isfile(file_path):
                    # 处理图片并保存到输出文件夹中
                    output_file_path = os.path.join(output_folder_path, file_name)
                    img_new = image_border(file_path, output_file_path, width, color=(0, 0, 0))
                    img_new.save((output_file_path))
                    print(f"Processed image: {output_file_path}")


if __name__ == "__main__":
    # 输入和输出文件夹路径
    input_dir = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\PMF_one-shot-classification_data\test'  # for PMF_matster
    output_dir = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\PMF_one-shot-classification_noise\border_noise\5'  # for PMF_matster

    # input_dir = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\images_evaluation_a'  # for PMF_matster
    # output_dir = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\images_evaluation_a_noise\border_noise_0'  # for PMF_matster

    # 处理图片
    process_images(input_dir, output_dir, 5, color=(0, 0, 0))
