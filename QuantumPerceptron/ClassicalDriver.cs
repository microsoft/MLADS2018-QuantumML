// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

////////////////////////////////////////////////////////////////////////////
// This file contains the classical code of the quantum perceptron
// which loads the data, calls quantum classification routines
// and performs search for model parameters.
////////////////////////////////////////////////////////////////////////////

using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using System;

namespace Microsoft.Quantum.MachineLearning
{
    class ClassicalDriver
    {
        // Call quantum classification on the given training data for the given model parameter
        // and return its success rate.
        static double GetClassificationSuccessRate(double[] data, long[] labels, double angle)
        {
            double s = 0;
            using (var qsim = new QuantumSimulator(true, 123))
            {
                // Change the following line to call QuantumClassifier_SuccessRate_Easy.Run to run pre-written model training code
                s = QuantumClassifier_SuccessRate.Run(qsim, angle, new QArray<double>(data), new QArray<long>(labels)).Result;
            }
            return s;
        }

        static void SaveAsCsv(double[] data, long[] labels)
        {
            string fileContents = "Label,Data" + Environment.NewLine;
            for (int i = 0; i < data.Length; ++i)
            { 
                fileContents += labels[i] + "," + data[i].ToString("F4") + Environment.NewLine;
            }
            System.IO.File.WriteAllText("trainingData.csv", fileContents);
        }

        /// <summary>
        /// Create a data set in the range [0, 2π] with a gap of the given size at the given central angle
        /// and a symmetrical gap at the angle π + the given central angle.
        /// </summary>
        /// <param name="size">Number of random data points</param>
        /// <param name="center">Where to create the gap</param>
        /// <param name="gap">Width of gap</param>
        /// <returns></returns>
        static double[] CreateSeparableDataset(int size, double center, double gap)
        {
            double[] data = new double[size];
            Random rnd = new Random(123);

            double max = Math.PI;

            // These variables are used to create the gap
            double lowerMax = center - gap / 2.0;
            double upperScale = (max - center - gap / 2.0) / (max - center);

            for (int i = 0; i < size; i++)
            {
                // 1. Generate a random number without taking the gap into account
                data[i] = rnd.NextDouble() * max;

                // 2. Shift it to create the gap
                if (data[i] <= center)
                {
                    // This is the simple case, just re-scale proportionally (3-simple rule)
                    data[i] *= lowerMax / center;
                }
                else
                {
                    // Slightly more complicated: invert, 3-simple rule to rescale, invert again
                    data[i] = max - data[i];
                    data[i] *= upperScale;
                    data[i] = max - data[i];
                }

                // 3. Spread to the full circle (2π) -- we'll have two gaps
                if (rnd.Next(2) == 1)
                {
                    data[i] += Math.PI;
                }
            }

            return data;
        }

        static void Main(string[] args)
        {
            // Larger dataset size gives more precise training result but slower training process
            int datasetSize = 200;

            // Prepare a perfectly separable training dataset
            double separationAngle = 2.0;
            double correctAngle = separationAngle - Math.PI / 2;
            double margin = 0.1;

            double[] data = CreateSeparableDataset(datasetSize, separationAngle, margin);

            // Assign labels to training data
            long[] labels = new long[datasetSize];
            for (int i = 0; i < datasetSize; ++i)
            {
                labels[i] = (data[i] > separationAngle && data[i] < separationAngle + Math.PI ? 1 : 0);
            }

            // Save the training data to file
            // SaveAsCsv(data, labels);

            // Check classification success rate on the angle that we know to be correct
            Console.Out.WriteLine($"For correct angle {correctAngle.ToString("F3")} success rate = " + 
                GetClassificationSuccessRate(data, labels, correctAngle));

            long msStart = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            // Do a ternary search on the classification angle (we know that the angle is between 0 and 2*PI).
            // Normally we would apply a better technique, like gradient search, but a demo which runs fast enough lacks precision for those techniques.
            double l = 0.0, r = 2 * Math.PI;
            int iter = 0;
            while (Math.Abs(l-r) > margin)     // stop when the length of the search interval is smaller than the margin
            {
                iter++;
                double m1 = l + (r - l) / 3;
                double m2 = r - (r - l) / 3;
                double s1 = GetClassificationSuccessRate(data, labels, m1);
                double s2 = GetClassificationSuccessRate(data, labels, m2);
                if (s1 <= s2)
                {
                    l = m1;
                } else
                {
                    r = m2;
                }
                Console.Out.WriteLine($"Iteration {iter}: angle {m1.ToString("F3")} -> {s1}, angle {m2.ToString("F3")} -> {s2}, narrowing search to [{l.ToString("F3")}, {r.ToString("F3")}]");
            }

            // Report training results (learned model parameter and classification success rate for it)
            double s = GetClassificationSuccessRate(data, labels, (l+r)/2);
            Console.Out.WriteLine($"Training result: angle {((l+r)/2).ToString("F3")} -> {s}");
            long msEnd = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;
            Console.Out.WriteLine("Training time " + (msEnd - msStart) / 1000.0);

            Console.WriteLine("Press any key to continue...");
            Console.ReadKey();

            ////////////////////////////////////////////////////////////////////////
            // Stretch goal: Write your own classifier!
            //
            // Now that you've trained your model, it's time to see how it performs on new data.
            // Generate new data following the same process as for the training data.
            // Write classification circuit QuantumClassifier following the suggestions in QuantumClassifier.qs.
            // Run it and compare classification results to the labels you assign when generating the data.
            ////////////////////////////////////////////////////////////////////////
        }
    }
}
