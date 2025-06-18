import { ReactNode, useState } from "react";
import Link from "next/link";
import Image from "next/image";
import { Inter } from "next/font/google";
import { useRouter } from "next/router";
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
    const [navOpen, setNavOpen] = useState(false);

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
            <div className="fixed h-dvh w-dvw -z-10 bg-[#2d3436]" />

            {/* Responsive Banner/Header */}
            <div className="w-full z-9999 text-white p-4 md:p-8 flex flex-col md:flex-row md:justify-between md:items-center">
                <div className="flex items-center justify-between w-full md:w-auto">
                    <Link href="/" className="flex items-center gap-2 font-bold text-3xl">
                        <Image
                            src={`${assetPrefix}/logo.png`}
                            alt="Logo"
                            width={40}
                            height={40}
                        />
                        MewNotch
                    </Link>
                    <button
                        className="md:hidden p-2 ml-2 focus:outline-none relative w-10 h-10 flex items-center justify-center"
                        aria-label="Toggle navigation menu"
                        onClick={() => setNavOpen((v) => !v)}
                    >
                        {/* Hamburger/Cross icon with animation */}
                        <span className="absolute top-1/2 left-1/2 w-6 h-6 -translate-x-1/2 -translate-y-1/2 flex flex-col justify-center items-center">
                            <span
                                className={`absolute h-0.5 w-6 bg-white rounded transition-all duration-300 translate-y-2 ${navOpen ? 'opacity-0' : 'opacity-100'}`}
                            />
                            <span
                                className={`absolute h-0.5 w-6 bg-white rounded my-1 transition-all duration-300 ${navOpen ? 'rotate-45' : 'rotate-0'}`}
                            />
                            <span
                                className={`absolute h-0.5 w-6 bg-white rounded my-1 transition-all duration-300 ${navOpen ? 'opacity-100 -rotate-45' : 'opacity-0 rotate-0'}`}
                            />
                            <span
                                className={`absolute h-0.5 w-6 bg-white rounded transition-all duration-300 -translate-y-2 ${navOpen ? 'opacity-0' : 'opacity-100'}`}
                            />
                        </span>
                    </button>
                </div>
                <nav
                    className={`flex flex-col md:flex-row items-end md:items-center gap-6 w-full px-5 md:px-0 md:w-auto transition-all duration-300 overflow-hidden ${navOpen ? 'max-h-60 py-4 opacity-100' : 'max-h-0 md:max-h-none py-0 opacity-0 md:opacity-100'} md:py-0 md:max-h-none`}
                >
                    <Link
                        href="/faq"
                        className={`text-lg font-bold transition-colors duration-200 ${currentPage === "faq" ? "underline" : ""}`}
                        onClick={() => setNavOpen(false)}
                    >
                        FAQs
                    </Link>
                    <Link
                        href="/support"
                        className={`text-lg font-bold transition-colors duration-200 ${currentPage === "support" ? "underline" : ""}`}
                        onClick={() => setNavOpen(false)}
                    >
                        Support
                    </Link>
                    <Link
                        href="/about"
                        className={`text-lg font-bold transition-colors duration-200 ${currentPage === "about" ? "underline" : ""}`}
                        onClick={() => setNavOpen(false)}
                    >
                        About
                    </Link>
                </nav>
            </div>
            {/* Main Content */}
            <div className="flex flex-col flex-grow w-dvw">
                {children}
            </div>
            {/* Fork on GitHub Ribbon */}
            {/* {currentPage === "" && (
                <div>
                    <Link
                        href="https://github.com/monuk7735/mew-notch/fork"
                        target="_blank"
                        rel="noopener noreferrer"
                        className="fixed right-0 bottom-0 w-80 flex flex-row gap-2 justify-center items-center font-bold text-lg p-2 bg-white rotate-[-45deg] hover:opacity-80 transition text-black z-50 translate-x-25 translate-y-[-30px] "
                        aria-label="GitHub"
                    >
                        <FaGithub size={28} />
                        <div>Star</div>
                    </Link>
                </div>
            )} */}
        </div>
    </>
    );
}
