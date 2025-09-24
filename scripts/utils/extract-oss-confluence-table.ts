import fs from 'fs/promises';
import path from 'path';
import https from 'https';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

interface Dependency {
    name: string;
    version: string;
    link: string;
    author: string;
    license: string;
}

interface PackageInfo {
    author?: {
        name: string;
    };
    license?: string;
}

async function extractOSSDependencies(packageJsonPath: string): Promise<Dependency[]> {
    const packageJson = JSON.parse(await fs.readFile(packageJsonPath, 'utf8'));
    const dependencies: { [key: string]: string } = {
        ...packageJson.dependencies,
        ...packageJson.devDependencies
    };

    return Object.entries(dependencies).map(([name, version]) => ({
        name,
        version,
        link: `https://www.npmjs.com/package/${name}`,
        author: 'n/a',
        license: 'Unknown'
    }));
}

function formatOSSForMarkdown(ossList: Dependency[]): string {
    const header = '| Name | Link | Author | Installed version | License type |\n';
    const separator = '| --- | --- | --- | --- | --- |\n';
    const rows = ossList.map(dep =>
        `| ${dep.name} | [${dep.name}](${dep.link}) | ${dep.author} | ${dep.version} | ${dep.license} |`
    ).join('\n');

    return header + separator + rows;
}

function fetchPackageInfo(packageName: string): Promise<{ author: string; license: string }> {
    return new Promise((resolve, reject) => {
        https.get(`https://registry.npmjs.org/${packageName}`, (res) => {
            let data = '';
            res.on('data', (chunk) => data += chunk);
            res.on('end', () => {
                try {
                    const packageInfo: PackageInfo = JSON.parse(data);
                    resolve({
                        author: packageInfo.author?.name ?? 'n/a',
                        license: packageInfo.license ?? 'Unknown'
                    });
                } catch (error) {
                    reject(error);
                }
            });
        }).on('error', (error) => reject(error));
    });
}

async function main() {
    const packageJsonPath = './package.json';
    const ossList = await extractOSSDependencies(packageJsonPath);

    for (const dep of ossList) {
        try {
            const info = await fetchPackageInfo(dep.name);
            dep.author = info.author;
            dep.license = info.license;
        } catch (error) {
            console.error(`Error fetching info for ${dep.name}: ${error instanceof Error ? error.message : String(error)}`);
        }
    }

    const formattedMarkdownOSS = formatOSSForMarkdown(ossList);
    const outputPathMarkdown = path.join(__dirname, 'oss-dependencies.md');
    await fs.writeFile(outputPathMarkdown, formattedMarkdownOSS);
    console.info(`Markdown OSS dependencies have been written to: ${outputPathMarkdown}`);
}

main().catch(error => console.error('An error occurred:', error instanceof Error ? error.message : String(error)));