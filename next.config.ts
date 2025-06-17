import type { NextConfig } from "next";

const BASE_PATH = "/mew-notch";
const isProd = process.env.NODE_ENV === "production";

const nextConfig: NextConfig = {
  output: "export",
  reactStrictMode: true,
  basePath: isProd ? BASE_PATH : "",
  images: {
    unoptimized: true,
    remotePatterns: [
      {
        protocol: "https",
        hostname: "monuk7735.github.io",
        port: "",
        pathname: BASE_PATH + "/**/*",
      },
    ],
  }
};

export default nextConfig;
