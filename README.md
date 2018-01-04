```
  ____       _____              _     
 |  _ \ _   |_   _|__  _ __ ___| |__  
 | |_) | | | || |/ _ \| '__/ __| '_ \ 
 |  __/| |_| || | (_) | | | (__| | | |
 |_|    \__, ||_|\___/|_|  \___|_| |_|
     _  |___/     _                   
    / \  | |_ __ (_)_ __   ___        
   / _ \ | | '_ \| | '_ \ / _ \       
  / ___ \| | |_) | | | | |  __/       
 /_/   \_\_| .__/|_|_| |_|\___|       
           |_|                        
```

----------------------------------------------------------------------------------------

[![](https://images.microbadger.com/badges/image/petronetto/pytorch-alpine.svg)](https://microbadger.com/images/petronetto/pytorch-alpine "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/petronetto/pytorch-alpine.svg)](https://microbadger.com/images/petronetto/pytorch-alpine "Get your own version badge on microbadger.com")
[![GitHub issues](https://img.shields.io/github/issues/petronetto/pytorch-alpine.svg)](https://github.com/petronetto/pytorch-alpine/issues)
[![GitHub license](https://img.shields.io/github/license/petronetto/pytorch-alpine.svg)](https://raw.githubusercontent.com/petronetto/pytorch-alpine/master/LICENSE)
[![Twitter](https://img.shields.io/twitter/url/https/github.com/petronetto/pytorch-alpine.svg?style=social)](https://twitter.com/intent/tweet?text=Wow:&url=https%3A%2F%2Fgithub.com%2Fpetronetto%2Fpytorch-alpine)


## Running the container

Simply run the following command and open your browser in http://localhost:5000.

```
docker run -it --name pytorch \
           -v $(PWD):/notebooks \
           -p 5000:5000 -d \
           petronetto/pytorch-alpine
```

## License
[BSD 3-Clause License](https://raw.githubusercontent.com/petronetto/pytorch-alpine/master/LICENSE)


Enjoy 😃