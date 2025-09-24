import fs from "fs";
import path from "path";
import { $ } from "zx";

function snakeToCamelCase(str: string): string {
    return str.replace(/_([a-z])/g, (_, letter) => letter.toUpperCase());
}

function processLine(line: string): string {
    const fieldRegex = /(\w+):/g;

    return line.replace(fieldRegex, (match) => snakeToCamelCase(match));
}

async function processFile(inputFilePath: string, outputFileName: string): Promise<void> {
    const inputData: string = fs.readFileSync(inputFilePath, "utf8");
    const lines: string[] = inputData.split("\n");
    const updatedLines: string[] = [];
    const interfaceDeclarationLineDef = /^(export )?interface BE[a-zA-Z_0-9]+ \{$/gm;
    const filteredLines = lines.filter((line) => line.match(interfaceDeclarationLineDef));

    const interfaceNames = filteredLines.map((line) => {
        return line.match(/(?<=^(export )?interface BE)[a-zA-Z_0-9]+(?= \{$)/gm)![0];
    });

    const sortedNames = interfaceNames.sort((name1, name2) => name2.length - name1.length);
    const fieldRgx = new RegExp(
        `(?<=(.*\W)?)(${interfaceNames.map((name) => `BE${name}`).join("|")})(?=(\W.*)?)`,
        "gm",
    );
    for (let i = 0; i < lines.length; i++) {
        const line = lines[i];

        if (line.match(interfaceDeclarationLineDef)) {
            updatedLines.push(
                line.replace(/(?<=(^export )?interface )BE[a-zA-Z_0-9]+(?= \{$)/gm, (match) => {
                    return match === "export " ? "export " : `${match.substring(2)}Data`;
                }),
            );
        } else if (line.match(fieldRgx)) {
            let updatedLine = processLine(line);
            sortedNames.forEach((name) => {
                const singleLineRegex = `(?<=(.*\\W)?)BE${name}(?=(\\W.*)?)`;
                const interfaceRgx = new RegExp(singleLineRegex, "gm");
                if (updatedLine.match(interfaceRgx)) {
                    updatedLine = updatedLine.replace(interfaceRgx, `${name}Data`);
                }
            });
            updatedLines.push(updatedLine);
        } else {
            updatedLines.push(processLine(line));
        }
    }
    const inputFolderPath: string = path.dirname(inputFilePath);
    const outputFolder: string = path.join(inputFolderPath, "frontend", "generated");
    await $`mkdir -p ${outputFolder}`;
    const outputFilePath: string = path.join(outputFolder, outputFileName);
    const outputData: string = updatedLines.join("\n");
    fs.writeFileSync(outputFilePath, outputData);

    console.info("Conversion complete. Output saved to", outputFilePath);
}

async function main(): Promise<void> {
    if (process.argv.length !== 3) {
        console.error("Usage: node script.js <input-file>");
        process.exit(1);
    }

    // Get input file path from command-line arguments
    const inputFilePath: string = process.argv[2];

    const inputFileName: string = path.basename(inputFilePath);
    const outputFileName: string = inputFileName.replace(/^BE/, "").replace(".ts", "Data.ts");

    processFile(inputFilePath, outputFileName);
}

await main();
