const { minify } = require("terser");

/**
 *
 * @param {Record<string,unknown>} a
 * @param {Record<string,unknown>} [b]
 */
const merge = (a, b) => {
    let c = {};
    for (const key of Object.keys(a)) {
        if (b && key in b) {
            c[key] = b[key];
        } else {
            c[key] = a[key];
        }
    }
    return c;
};
/**
 *
 * @param {string} code
 * @param {import("terser").MinifyOptions} [opts]
 */
const miniFyJs = async (code, opts) => {
    /**
     * @type {import("terser").MinifyOptions}
     */
    const defaultOptions = {
        sourceMap: true,
    };
    const options = merge(defaultOptions, opts);
    const result = await minify(code, options);
    return {
        compiled: result.code,
        source_map: result.map ?? null,
    };
};

async function readStdin() {
    const chunks = [];

    for await (const chunk of process.stdin) {
        chunks.push(chunk);
    }

    return chunks.join("");
}

async function runCli() {
    const stdin = await readStdin();
    const { code, opts } = JSON.parse(stdin);
    const result = await miniFyJs(code, opts);
    process.stdout.write(JSON.stringify(result));
}

if (require.main === module) {
    runCli().catch((error) => {
        process.stderr.write(
            `${error instanceof Error ? error.message : String(error)}`,
        );
        process.exit(1);
    });
}
