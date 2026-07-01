const esbuild = require("esbuild");

async function build() {
    await esbuild.build({
        entryPoints: ["tools/index.js"],
        bundle: true,
        format: "cjs",
        outdir: "assets",
        sourcemap: true,
        minify: true,
    });
}

build().catch((err) => console.log(err));
