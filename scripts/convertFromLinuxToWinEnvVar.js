const fs = require('fs');

// Function to convert Linux env file to Windows format
const convertEnvFile = (inputFilePath, outputFilePath) => {
  // Read the content of the Linux env file
  fs.readFile(inputFilePath, 'utf8', (err, data) => {
    if (err) {
      console.error('Error reading the file:', err);
      return;
    }

    // Convert the file content to Windows format
    const windowsFormat = data
      .split('\n')
      .map((line) => line.trim()) // Trim whitespace
      .filter((line) => line && line.startsWith('export ')) // Filter valid export lines
      .map((line) => line.replace(/^export\s+/, '').replace(/'/g, '')) // Remove 'export' and quotes
      .join('\n'); // Join back to string

    // Write the converted content to the output file
    fs.writeFile(outputFilePath, windowsFormat, 'utf8', (err) => {
      if (err) {
        console.error('Error writing the file:', err);
      } else {
        console.log(`Converted file saved as: ${outputFilePath}`);
      }
    });
  });
};

// Specify the input and output file paths
const inputFilePath = 'envVarExamples/envVars_fromClientCredentials.txt'; // Change this to your input file path
const outputFilePath = 'envVarExamples/envVars.txt'; // Change this to your desired output file path

// Run the conversion
convertEnvFile(inputFilePath, outputFilePath);
