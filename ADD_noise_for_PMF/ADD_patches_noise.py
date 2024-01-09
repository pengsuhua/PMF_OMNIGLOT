
import os
import cv2
import numpy as np
import shutil


# 设置输入路径和输出路径
input_folder = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\PMF_one-shot-classification_data\test'   # for PMF_matster
output_folder = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\PMF_one-shot-classification_noise\patches_noise\10'  # for PMF_matster

# input_folder = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\images_evaluation_a'   # for PMF_matster
# output_folder = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\images_evaluation_a_noise\patches_noise_0'  # for PMF_matster

# 定义方块干扰的参数
num_blocks = 10  # 方块数量
block_size = 10  # 方块大小
block_color = (0, 0, 0)  # 方块颜色，这里使用黑色

# 创建output_patches_noise文件夹（如果不存在）
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

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
            image = cv2.imread(file_path)

            # 添加方块干扰
            for _ in range(num_blocks):
                # 随机生成方块的位置
                x = np.random.randint(0, image.shape[1] - block_size)
                y = np.random.randint(0, image.shape[0] - block_size)
                # 绘制方块
                cv2.rectangle(image, (x, y), (x + block_size, y + block_size), block_color, -1)

            # 保存结果
            output_path = os.path.join(output_directory, file)  # 输出图片的路径
            cv2.imwrite(output_path, image)









