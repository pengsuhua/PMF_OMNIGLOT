import os
import cv2

input_folder = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\PMF_one-shot-classification_data\test'   # for PMF_matster
output_folder = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\PMF_one-shot-classification_noise\grid_noise\10'  # for PMF_matster


# input_folder = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\images_evaluation_a'   # for PMF_matster
# output_folder = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\images_evaluation_a_noise\grid_noise_0'  # for PMF_matster

grid_size = (10, 10)  # 网格数量
line_color = (0, 0, 0)  # 网格线颜色

# 遍历输入文件夹下的所有文件夹
for root, dirs, files in os.walk(input_folder):
    for dir_name in dirs:
        input_dir = os.path.join(root, dir_name)  # 输入子文件夹路径
        output_dir = os.path.join(output_folder, dir_name)  # 输出子文件夹路径
        os.makedirs(output_dir, exist_ok=True)  # 创建对应的输出子文件夹

        # 遍历子文件夹下的图像文件
        for file_name in os.listdir(input_dir):
            if file_name.endswith(".png"):
                input_image_path = os.path.join(input_dir, file_name)  # 输入图像路径
                output_image_path = os.path.join(output_dir, file_name)  # 输出图像路径

                # 加载图像
                image = cv2.imread(input_image_path)

                # 计算每个格子的大小
                cell_width = image.shape[1] // grid_size[1]
                cell_height = image.shape[0] // grid_size[0]

                # 绘制垂直线
                for x in range(0, image.shape[1], cell_width):
                    cv2.line(image, (x, 0), (x, image.shape[0]), line_color)

                # 绘制水平线
                for y in range(0, image.shape[0], cell_height):
                    cv2.line(image, (0, y), (image.shape[1], y), line_color)

                # 保存结果
                cv2.imwrite(output_image_path, image)


