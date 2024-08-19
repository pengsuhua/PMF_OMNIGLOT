# PMF_OMNIGLOT
This is  a arobust classification method that extends the classical paradigm of robust geometric model fitting.A probabilistic program is hierarchically composed of a number of procedures with stochastic parameters. Specific values of the parameters correspond to a specific derivation of the probabilistic program. In 
this paper, the probabilistic program is used to generate characters. That is, a derivation of the program is able to generate an image of a character. Probabilistic program induction involves searching for the derivation that best matches the given data, known as the optimal derivation, from the set of all possible derivations of a probabilistic program. PMF is a special case of probabilistic program induction. It aims to find a model instance from a collection of geometric model instances that can best explain a given set of data points.

## PMF Model 
### **The process of the training process of our method:**
![train_latest ](https://github.com/user-attachments/assets/5d27504c-03fa-4c09-92cc-3a1c61893ac8)
### **The process of the testing process of our method:**
![test_latest](https://github.com/user-attachments/assets/cabeae83-aca6-4a07-8983-166d294e691c)



## Comparative Experiments
our comparative analysis involves: (1) a comparison with the Bayesian probabilistic program (BPL)[1] method ; and (2) a comparison with deep learning based few-shot image classification methods [2]-[13].
### **RESULT 1：**
![noise_level_1_result](https://github.com/user-attachments/assets/f62e4b31-3a83-459c-8872-5ea4a689a734)
### **RESULT 2:**
![noise_level_2_result](https://github.com/user-attachments/assets/c6a3339f-0fa4-42c4-8eef-fddb5759b718)
### **some character models reconstructed from noise-contaminated characters:**
![generate_model](https://github.com/pengsuhua/PMF_OMNIGLOT/assets/116246948/8f45f3ec-36cb-4b64-94a8-082d5f077dba)
## Conclusion
The experimental results collectively demonstrate the superior performance of the PMF method across various noise conditions, especially in handling grid, salt-and-pepper, patches, and deletion noises. Not only did PMF outperform several comparative methods at noise level 1, but it also maintained a high classification accuracy when the noise level was elevated to the second stage, indicating its remarkable robustness.

## References
[1] Lake B M, Salakhutdinov R, Tenenbaum J B. Human-level concept learning through probabilistic program induction[J]. Science, 2015, 350(6266): 1332-1338. /
[2] Lee D B, Min D, Lee S, et al. Meta-gmvae: Mixture of gaussian vae for unsupervised meta-learning[C]//International Conference on Learning Representations. 2020./
[3] Qi G, Yu H. CMVAE: causal meta VAE for unsupervised meta-learning[C]//Proceedings of the AAAI Conference on Artificial Intelligence. 2023, 37(8): 9480-9488./
[4] Snell J, Swersky K, Zemel R. Prototypical networks for few-shot learning[J]. Advances in neural information processing systems, 2017, 30./
[5] Li S, Liu F, Hao Z, et al. Unsupervised few-shot image classification by learning features into clustering space[C]//European Conference on Computer Vision. Cham: Springer Nature Switzerland, 2022: 420-436./
[6] Sendera M, Przewięźlikowski M, Karanowski K, et al. Hypershot: Few-shot learning by kernel hypernetworks[C]//Proceedings of the IEEE/CVF winter conference on applications of computer vision. 2023: 2469-2478./
[7] Vinyals O, Blundell C, Lillicrap T, et al. Matching networks for one shot learning[J]. Advances in neural information processing systems, 2016, 29./
[8] Borycki P, Kubacki P, Przewięźlikowski M, et al. Hypernetwork approach to Bayesian maml[J]. arXiv preprint arXiv:2210.02796, 2022./
[9] Przewięźlikowski M, Przybysz P, Tabor J, et al. Hypermaml: Few-shot adaptation of deep models with hypernetworks[J]. Neurocomputing, 2024, 598: 128179./
[10] Finn C, Abbeel P, Levine S. Model-agnostic meta-learning for fast adaptation of deep networks[C]//International conference on machine learning. PMLR, 2017: 1126-1135./
[11] Borycki P, Kubacki P, Przewięźlikowski M, et al. Hypernetwork approach to Bayesian maml[J]. arXiv preprint arXiv:2210.02796, 2022./[12] Nguyen Q H, Nguyen C Q, Le D D, et al. Enhancing few-shot image classification with cosine transformer[J]. IEEE Access, 2023, 11: 79659-79672./[13] Doersch C, Gupta A, Zisserman A. Crosstransformers: spatially-aware few-shot transfer[J]. Advances in Neural Information Processing Systems, 2020, 33: 21981-21993.








