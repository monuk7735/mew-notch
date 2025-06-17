import { ReactNode } from "react";
import Link from "next/link";
import Image from "next/image";
import { Inter } from "next/font/google";
import { useRouter } from "next/router";
import { FaGithub } from "react-icons/fa";
import Head from "next/head";
import nextConfig from "../next.config";

const inter = Inter({
    subsets: ["latin"],
    weight: ["400", "500", "700"],
    variable: "--font-inter",
});

interface HomeContainerProps {
    children: ReactNode;
}

export default function HomeContainer({ children }: HomeContainerProps) {
    const router = useRouter();

    // Get the current page type from the route
    const currentPage = router.pathname.split("/")[1] || "";

    // Helper to prefix asset paths for production (GitHub Pages) or use root in dev
    const assetPrefix = nextConfig.basePath || "";

    return (<>
        <Head>
            <link rel="icon" type="image/x-icon" href={`${assetPrefix}/favicon.ico`} />
        </Head>
        <div className={`${inter.className} flex flex-col h-dvh w-dvw`}>
            {/* Background Layer */}
            <div className="fixed inset-0 -z-10 bg-[#2d3436]" />

            <div
                className="w-full top-0 z-30 text-white p-8 flex justify-between items-center"
            >
                <Link href="/" className="flex items-center gap-2 font-bold text-3xl">
                    <Image
                        src={`${assetPrefix}/logo.png`}
                        alt="Logo"
                        width={40}
                        height={40}
                    />
                    MewNotch
                </Link>

                <div className="flex-grow" />

                <div className="flex items-center gap-6">
                    <Link
                        href="/about"
                        className={`text-lg font-bold transition-colors duration-200 ${currentPage === "about" ? "underline" : ""}`}
                    >
                        About
                    </Link>
                </div>
            </div>

            {/* Main Content */}
            <div className="flex flex-col flex-grow w-dvw">
                {children}
            </div>

            {/* Fork on GitHub Ribbon */}
            {currentPage !== "" && (
                <div>
                    <Link
                        href="https://github.com/monuk7735/mew-notch/fork"
                        target="_blank"
                        rel="noopener noreferrer"
                        className="fixed right-0 bottom-0 w-80 flex flex-row gap-2 justify-center items-center font-bold text-lg p-2 bg-white rotate-[-45deg] hover:opacity-80 transition text-black z-50 translate-x-25 translate-y-[-30px] "
                        aria-label="GitHub"
                    >
                        <FaGithub size={28} />
                        <div>Fork</div>
                    </Link>
                </div>
            )}
        </div>
    </>
    );
}
