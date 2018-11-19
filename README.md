# Welcome!

This repository contains the materials for the "Introduction to Quantum Machine Learning" workshop. 

In this workshop the participants will get hands-on experience implementing the simplest quantum machine learning algorithm - a quantum perceptron.

## Installing and Getting Started

To work on this tutorial, you'll need to install the [Quantum Development Kit](https://docs.microsoft.com/quantum), available for Windows 10, macOS, and for Linux.
Please see the [install guide for the Quantum Development Kit](https://docs.microsoft.com/quantum/install-guide/) for the detailed instructions. We recommend that you use Visual Studio 2017 or Visual Studio Code.

If you have Git installed, go on and clone the Microsoft/MLADS2018-QuantumML repository. From your favorite command line:

```bash
git clone https://github.com/Microsoft/MLADS2018-QuantumML.git
```

> **TIP**: Both Visual Studio 2017 and Visual Studio Code make it easy to clone repositories from within your development environment.
> See the [Visual Studio 2017](https://docs.microsoft.com/en-us/vsts/git/tutorial/clone?view=vsts&tabs=visual-studio#clone-from-another-git-provider) and [Visual Studio Code](https://code.visualstudio.com/docs/editor/versioncontrol#_cloning-a-repository) documentation for details.

If you don't have Git installed, you can manually download a [standalone copy of the tutorials](https://github.com/Microsoft/MLADS2018-QuantumML/archive/master.zip).

## Tutorial Structure

The tutorial contains the template of the algorithm which you will work on and the classical harness used for running your code. The project is laid out as below.

```
README.md                           # Tutorial instructions
QuantumPerceptron/
  QuantumPerceptron.sln             # Visual Studio 2017 solution file.
  QuantumPerceptron.csproj          # Project file used to build both classical and quantum code.

  QuantumClassifier.qs              # Q# source code containing the template of the quantum perceptron.
  QuantumClassifier_Easy.qs         # Q# source code containing the implementations of the quantum perceptron.
  ClassicalDriver.cs                # C# source code used to load the data, invoke the Q# code and do classical processing.
```

To open the tutorial in Visual Studio 2017, open the `QuantumPerceptron.sln` solution file.

To open the tutorial in Visual Studio Code, open the `QuantumPerceptron/` folder.
Press Ctrl + Shift + P / ⌘ + Shift + P to open the Command Palette and type "Open Folder" on Windows 10 or Linux or "Open" on macOS.

> **TIP**: Almost all commands available in Visual Studio Code can be found in the Command Palette.
> If you ever get stuck, press Ctrl + Shfit + P / ⌘ + Shift + P and type some letters to search through all available commands.

> **TIP**: You can also launch Visual Studio Code from the command line if you prefer:
> ```bash
> code QuantumPerceptron/
> ```

## Working on the Tutorial

Once you have the project open, you can build it and run it (`F5` in Visual Studio, `dotnet run` in Visual Studio Code terminal or command line). 

Initially the quantum code does nothing and always reports classification success rate of -1. 
Once you fill in the correct code in `QuantumClassifier.qs` file, the code will learn the model parameter which provides the best separation of the given classes.
If you get stuck or run out of time and just want to see the model train,
`QuantumClassifier_Easy.qs` file contains the full code for model training. You can look up the place in which you got stuck or switch to running the code in that file.

As a stretch goal, try to implement the classical harness and the quantum classification circuit to generate new data and classify it using your trained model.

## Useful Links

* You can find Q# language quick reference [here](./qsharp-quick-reference.pdf).


* To improve your experience in the workshop, we suggest you to go through the BasicGates kata from the [Quantum Katas](https://github.com/Microsoft/QuantumKatas) project. 
It teaches you the basic gates used in quantum computing and helps you get more comfortable with Q#. 
Superposition and Measurement katas are the next best follow-up topics.

* You can find the slides used in the introductory part of the workshop [here](./QuantumPerceptron.pptx).

---

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
