@def title = "Tutorial"

# Tutorial, v0.1

## Git & GitHub

If you don't have Git, you need to install it. The installation will depend on your operating system. \

If you don't have a [GitHub] (https://github.com/) account yet, create an account. \

## Fork & Clone CUP of TEA

Go to [the CUPofTEA repository] (https://github.com/CUPofTEAproject/www.cupoftea.earth) and click on the Fork button in the top right corner. This will create a copy of the CUPofTEA codes in your personal GitHub account. \

Clone that forked repository on your local computer. \

## input folder 

At the root of your CUPofTEA repository, create a folder named "input". This folder contains land databases and will be ignored by Git and GitHub. Download databases in this folder, or put your datasets in it. \

## Write your analysis code in the "functions" folder

The "functions" folder contains all scripts of analysis done using data from the "input" folder. For version control, you should have a script that can download the latest version of the data you are analysing. Your analysis script should be able to run on new versions. \

## Commit & Push 

While you are working on your scripts, you should synchronise it between your local computer and your GitHub branch of CUPofTEA, using git commit and push commands. 

## Testing the integration of your outputs on CUPofTEA 

To test if your analysis outputs (figures, data) are working properly, you can use the package Franklin in the Julia programming language, and use the function serve().   

## Submit a Pull Request

Once you are happy with your work, submit a Pull Request from your personal GitHub copy of CUPofTEA to the main repository. 

