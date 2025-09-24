import prompts from "prompts";
import fs from "fs";

fs.rmSync("env.temp", { force: true });
const env = await (async () => {
    const response = await prompts({
        type: "autocomplete",
        name: "environment",
        message: "Pick environment",
        initial: "dev",
        // default: undefined,
        choices: [
            { title: "DEV", value: "dev" },
            { title: "MOCK", value: "mock" },
            { title: "PROD", value: "prod" },
        ],
    });

    return response.environment;
})();

if (env) {
    fs.writeFileSync("env.temp", env);
}
