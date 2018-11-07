// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

////////////////////////////////////////////////////////////////////////////
// This file contains the easy version of the workshop.
// All the quantum code is already written, and you can run the program to see how it works.
// To switch to this version, replace QuantumClassifier_SuccessRate in ClassicalDriver.cs
// with QuantumClassifier_SuccessRate_Easy.
//
// We recommend you to try the harder version (QuantumClassifier.qs file),
// where you have to write Q# model training code following prompts in the comments,
// and eventually write the classifier code on your own.
////////////////////////////////////////////////////////////////////////////

namespace Microsoft.Quantum.MachineLearning {
    
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    
    
    ////////////////////////////////////////////////////////////////////////
    // Encoding circuit
    // 
    // # Summary
    // Prepares two qubits in a state which represents a point in the training dataset.
    // # Inputs
    // data :       The input vector (single floating-point number)
    // label :      The input label (0 or 1)
    // dataQubit :  The qubit to be prepared in a state which represents input vector
    // labelQubit : The qubit to be prepared in a state which represents the label 
    //              (|0⟩ or |1⟩ for labels 0 or 1, respectively)
    ////////////////////////////////////////////////////////////////////////
    operation EncodeDataInQubits_Easy (
        data : Double, 
        label : Int, 
        dataQubit : Qubit, 
        labelQubit : Qubit) : Unit {

        // Make sure both qubits start in |0⟩ state (you can use library operation Reset)
        Reset(dataQubit);
        Reset(labelQubit);
        
        // Encode the input vector in dataQubit state using Ry rotation gate.
        // Note that the rotation angle has to be exactly "data" to be consistent with the labels generation in Driver.cs
        Ry(data, dataQubit);
        
        // Encode the label in labelQubit state: |0⟩ or |1⟩ for labels 0 or 1 (you can use X gate to change qubit state |0⟩ to |1⟩)
        if (label == 1) {
            X(labelQubit);
        }
    }
    
    
    ////////////////////////////////////////////////////////////////////////
    // Single-shot single-point validation circuit
    //
    // # Summary
    // Classifies a data point encoded as a qubit and validates the result against the expected label.
    // # Inputs
    // alpha      : The model parameter used for classification
    // dataQubit  : The qubit which represents the input state
    // labelQubit : The qubit which represents the expected label of the input state
    // # Result
    // True if the data point has been classified correctly, 
    // false if it has been misclassified.
    // 
    // In classification scenario, the circuit will be the same, but the label qubit will always start in |0⟩ state,
    // and to get the classification result you'll measure it.
    ////////////////////////////////////////////////////////////////////////
    operation Validate_Easy (
        alpha : Double, 
        dataQubit : Qubit, 
        labelQubit : Qubit) : Bool {
        
        // Rotate the state of the data qubit by -alpha;
        // this will get it close to the |0⟩ state if the data point belonged to class 0,
        // and to the |1⟩ state if the data point belonged to class 1
        Ry(-alpha, dataQubit);

        // Apply CNOT with data qubit as control and label qubit as target 
        // to compute XOR of the expected label and the computed label on labelQubit
        CNOT(dataQubit, labelQubit);

        // Measure the label qubit in computational basis

        // If the measurement result is |0⟩, XOR of the expected label and the computed label is 0, 
        // which means that the labels are the same and classification was correct.
        // Return the classification success
        return M(labelQubit) == Zero;
    }
    
    
    ////////////////////////////////////////////////////////////////////////
    // Full validation routine
    //
    // # Summary
    // Given the value of the model parameter (average rotation angle of the data points in class 0),
    // # Inputs
    // alpha      : The model parameter used for classification
    // dataPoints : An array of training vectors (individual floating-point numbers)
    // labels     : An array of training labels (0 or 1)
    // # Result
    // The success rate of classification for the given model parameter.
    ////////////////////////////////////////////////////////////////////////
    operation QuantumClassifier_SuccessRate_Easy (
        alpha : Double, 
        dataPoints : Double[], 
        labels : Int[]) : Double {
        
        let N = Length(dataPoints);
        // The number of times each point is classified; larger values give higher accuracy but longer run time
        let nSamples = 201;
        // Define a mutable variable to store the number of correctly classified points in the dataset
        mutable nCorrectPoints = 0;
        
        // Allocate two qubits to be used in the classification
        using ((dataQubit, labelQubit) = (Qubit(), Qubit())) {
            
            // Iterate over all points of the dataset
            for (i in 0 .. N - 1) {
                
                // Define a mutable variable to store the number of successful classification runs
                mutable nCorrectClassificationRuns = 0;
                
                // Classify i-th data point by running classification circuit nSamples times
                for (j in 1 .. nSamples) {
                    // Prepare data qubit and label qubit in a state which encodes the j-th data point
                    EncodeDataInQubits_Easy(dataPoints[i], labels[i], dataQubit, labelQubit);

                    // Run classification on the prepared qubits and count the runs when it succeeded
                    if (Validate_Easy(alpha, dataQubit, labelQubit)) {
                        set nCorrectClassificationRuns = nCorrectClassificationRuns + 1;
                    }
                }
                
                // The point in the dataset has been classified correctly if 
                // the share of runs on which classification succeeded is greater than 50%.
                if (nCorrectClassificationRuns * 2 > nSamples) {
                    set nCorrectPoints = nCorrectPoints + 1;
                }
            }

            // Clean up both qubits before deallocating them using library operation Reset.
            Reset(dataQubit);
            Reset(labelQubit);
        }
        
        // Return the success rate of the classification (the percentage of points that have been classified correctly)
        // Note that you need ToDouble library function to convert integer numbers to doubles explicitly
        return ToDouble(nCorrectPoints) / ToDouble(N);
    }
}
