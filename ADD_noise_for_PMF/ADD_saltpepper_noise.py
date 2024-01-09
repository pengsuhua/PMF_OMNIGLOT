import cv2
import numpy as np
import os
import shutil

# 添加椒盐噪声
def saltpepper_noise(image, proportion):
    '''
    此函数用于给图片添加椒盐噪声
    image       : 原始图片
    proportion  : 噪声比例
    '''
    image_copy = image.copy()
    # 求得其高宽
    img_Y, img_X = image.shape
    # 噪声点的 X 坐标
    X = np.random.randint(img_X, size=(int(proportion * img_X * img_Y),))
    # 噪声点的 Y 坐标
    Y = np.random.randint(img_Y, size=(int(proportion * img_X * img_Y),))
    # 噪声点的坐标赋值
    image_copy[Y, X] = np.random.choice([0, 255], size=(int(proportion * img_X * img_Y),))

    # 噪声容器
    sp_noise_plate = np.ones_like(image_copy) * 127
    # 将噪声给噪声容器
    sp_noise_plate[Y, X] = image_copy[Y, X]
    return image_copy, sp_noise_plate  # 这里也会返回噪声，注意返回值


# 添加高斯噪声
def gaussian_noise(img, mean, sigma):
    '''
    此函数用将产生的高斯噪声加到图片上
    传入:
        img   :  原图
        mean  :  均值
        sigma :  标准差
    返回:
        gaussian_out : 噪声处理后的图片
        noise        : 对应的噪声
    '''
    # 将图片灰度标准化
    img = img / 255
    # 产生高斯 noise
    noise = np.random.normal(mean, sigma, img.shape)
    # 将噪声和图片叠加
    gaussian_out = img + noise
    # 将超过 1 的置 1，低于 0 的置 0
    gaussian_out = np.clip(gaussian_out, 0, 1)
    # 将图片灰度范围的恢复为 0-255
    gaussian_out = np.uint8(gaussian_out*255)
    # 将噪声范围搞为 0-255
    # noise = np.uint8(noise*255)
    return gaussian_out, noise # 这里也会返回噪声，注意返回值



#---------------------------------------------------------------------------------------处理部分代码----------------------------------------------------------------------------------------------------------------------------------------
#设置文件夹路径
##PMF里只要给test部分的数据集加上噪声！！
folder_path = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\PMF_one-shot-classification_data\test'   # for PMF_matster
output_folder_path = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\PMF_one-shot-classification_noise\saltpepper_noise\0.4'  # for PMF_matster .。。。。这里的0表示此时加入的噪声的强度为0.


# folder_path = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\images_evaluation_a'   # for PMF_matster
# output_folder_path = r'D:\PSH-Learning\172.24.97.7_character\172.24.97.7_PSH\ADD_noise_1\images_evaluation_a_noise\saltpepper_noise_0'  # for PMF_matster .。。。。这里的0表示此时加入的噪声的强度为0.

##------------------------------------------------------------------处理---------------------------------------------------------------------------------------------------------

# 创建output_gausse_noise文件夹（如果不存在）
if not os.path.exists(output_folder_path):
    os.makedirs(output_folder_path)

# 遍历文件夹
for folder_name in os.listdir(folder_path):
    folder_dir = os.path.join(folder_path, folder_name)
    if not os.path.isdir(folder_dir):
        continue

    # 创建相应的子文件夹
    output_subfolder_path = os.path.join(output_folder_path, folder_name)
    if not os.path.exists(output_subfolder_path):
        os.makedirs(output_subfolder_path)

    # 遍历文件夹中的图片文件
    for file_name in os.listdir(folder_dir):
        file_path = os.path.join(folder_dir, file_name)
        if not file_path.endswith(('.bmp', '.jpg', '.jpeg', '.png')):
            continue

        # 读取图片
        img = cv2.imread(file_path, cv2.IMREAD_GRAYSCALE)

        # # 加入高斯噪声
        # gaussian_out, _ = gaussian_noise(img, 0, 0.03)

        #加入椒盐噪声
        saltpepper_out, _ = saltpepper_noise(img,0.4)   # 0.03：表示噪声比例。改变这个就可以改变噪声的强度。

        # 保存带噪声的图片到相应的子文件夹中
        output_file_path = os.path.join(output_subfolder_path, f'noisy_{file_name}')
        # cv2.imwrite(output_file_path, gaussian_out)
        cv2.imwrite(output_file_path, saltpepper_out)


