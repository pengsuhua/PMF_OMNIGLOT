# PMF_OMNIGLOT
This is  a arobust classification method that extends the classical paradigm of robust geometric model fitting.
|                | PMF    | BPL    | 对比结果（PMF > or < BPL） |
| -------------- | ------ | ------ | -------------------------- |
| grid噪声       | 26.25% | 30.8%  | lower:4.55%                |
| saltpepper噪声 | 80.75% | 37.2%  | **higher:43.55%**          |
| patches噪声    | 69.25% | 31.8%  | **higher:37.45%**          |
| deletion噪声   | 79%    | 90.75% | lower:11.75%               |
| clutter噪声    | 39.5%  | 13.5%  | **higher:26%**             |
| border噪声     | 37.75% | 31.8%  | **higher:5.95%**           |
