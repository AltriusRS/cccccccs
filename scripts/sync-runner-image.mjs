import { mkdir, writeFile } from "node:fs/promises";

const files = {
    readme:
        "https://raw.githubusercontent.com/actions/runner-images/main/images/ubuntu/Ubuntu2404-Readme.md",
    toolset:
        "https://raw.githubusercontent.com/actions/runner-images/main/images/ubuntu/toolsets/toolset-2404.json",
};

async function getText(url) {
    const res = await fetch(url);
    if (!res.ok) {
        throw new Error(`Failed to fetch ${url}: ${res.status}`);
    }
    return await res.text();
}

async function main() {
    const [readme, toolsetRaw] = await Promise.all([
        getText(files.readme),
        getText(files.toolset),
    ]);

    let toolset;
    try {
        toolset = JSON.parse(toolsetRaw);
    } catch {
        toolset = { raw: toolsetRaw };
    }

    await mkdir("generated", { recursive: true });

    await writeFile(
        "generated/upstream.json",
        JSON.stringify(
            {
                fetchedAt: new Date().toISOString(),
                files,
                readmeLength: readme.length,
                toolset,
            },
            null,
            2,
        ),
    );

    await writeFile(
        "upstream-state.json",
        JSON.stringify(
            {
                fetchedAt: new Date().toISOString(),
                ubuntuVersion: "24.04",
                sourceFiles: files,
            },
            null,
            2,
        ),
    );
}

main().catch((err) => {
    console.error(err);
    process.exit(1);
});