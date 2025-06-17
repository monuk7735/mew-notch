import HomeContainer from "@/components/home-container";
import Link from "next/link";
import { ReactNode, useEffect, useState, useMemo } from "react";
import { FaApple, FaGithub } from "react-icons/fa";
import nextConfig from "../next.config";
import Head from "next/head";

export default function Home() {

  // const collapsed = [
  //   {
  //     title: "Brightness Control",
  //     desc: "Displays the current brightness level in the notch.",
  //   },
  //   {
  //     title: "Input and Output Volume",
  //     desc: "Shows the current input and output volume levels.",
  //   },
  //   {
  //     title: "Audio Device Changes",
  //     desc: "Notifies when the audio devices change.",
  //   },
  //   {
  //     title: "Power Status and Remaining Time",
  //     desc: "Displays the current power status and remaining time.",
  //   },
  //   {
  //     title: "Minimal and Non-intrusive",
  //     desc: "Provides a minimal and non-intrusive experience.",
  //   }
  // ];

  // const previewFiles = [
  //   "/preview/brightness/minimal.mov",
  //   "/preview/speaker/minimal.mov",
  //   "/preview/microphone/minimal.mov",
  //   "/preview/media/player.mov"
  // ];

  const phrases = useMemo(() => [
    "Useful.",
    "Beautiful.",
    "Yours."
  ], []);
  const [displayed, setDisplayed] = useState("");
  const [phraseIdx, setPhraseIdx] = useState(0);
  const [charIdx, setCharIdx] = useState(0);
  const [deleting, setDeleting] = useState(false);

  useEffect(() => {
    let timeout: NodeJS.Timeout;
    if (!deleting && charIdx < phrases[phraseIdx].length) {
      timeout = setTimeout(() => {
        setDisplayed(phrases[phraseIdx].slice(0, charIdx + 1));
        setCharIdx(charIdx + 1);
      }, 80);
    } else if (!deleting && charIdx === phrases[phraseIdx].length) {
      timeout = setTimeout(() => setDeleting(true), 1200);
    } else if (deleting && charIdx > 0) {
      timeout = setTimeout(() => {
        setDisplayed(phrases[phraseIdx].slice(0, charIdx - 1));
        setCharIdx(charIdx - 1);
      }, 40);
    } else if (deleting && charIdx === 0) {
      timeout = setTimeout(() => {
        setPhraseIdx((phraseIdx + 1) % phrases.length);
        setDeleting(false);
      }, 400);
    }
    return () => clearTimeout(timeout);
  }, [charIdx, deleting, phraseIdx, phrases]);

  // Helper to prefix asset paths for production (GitHub Pages) or use root in dev
  const assetPrefix = nextConfig.basePath || "";

  return (<>
    <Head>
      <title>MewNotch</title>
    </Head>
    <div
      className="w-dvw flex-wrap flex flex-col flex-grow gap-8"
      style={{ scrollSnapType: 'y mandatory' }}
    >

      <div className="h-dvh -mt-30 pt-30 flex flex-col items-center justify-evenly gap-8 flex-1">
        <div className="flex flex-col gap-4 font-bold text-white text-center">
          <div className="text-lg">Make your MacBook Notch</div>
          <span className="text-5xl text-blue-400">
            {displayed}
            <span className="border-r-2 border-blue-400 animate-pulse ml-1" />
          </span>
        </div>

        <div className="lg:absolute lg:-translate-x-1/2 lg:-translate-y-1/2 lg:top-1/2 lg:left-1/2 -z-10 w-full p-8 lg:p-16">
          <video
            className="rounded-lg lg:rounded-3xl shadow-lg w-full lg:brightness-55"
            autoPlay
            loop
            src={`${assetPrefix}/preview/main.mov`}
          />
        </div>

        {/* Download and GitHub links */}
        <div className="flex flex-row flex-wrap gap-4 items-center justify-center px-8">
          <Link
            href="https://github.com/monuk7735/mew-notch/releases"
            target="_blank"
            rel="noopener noreferrer"
            className="px-6 py-3 rounded-lg bg-blue-500 hover:bg-blue-600 text-white font-semibold shadow transition-colors duration-200 text-lg flex items-center gap-2"
          >
            <FaApple className="text-2xl" />
            Download for macOS
          </Link>
          <Link
            href="https://github.com/monuk7735/mew-notch"
            target="_blank"
            rel="noopener noreferrer"
            className="px-6 py-3 rounded-lg bg-gray-800 hover:bg-gray-700 text-white font-semibold shadow transition-colors duration-200 text-lg border border-gray-700 flex items-center gap-2"
          >
            <FaGithub className="text-2xl" />
            Open Source on GitHub
          </Link>
        </div>

        <div>

        </div>

        {/* <div className="flex-grow"></div> */}
      </div>

      {/* {collapsed.map((page, i) => (
        <div
          key={i}
          className="flex flex-grow flex-col items-center justify-center p-8"
        >
          <h2 className="text-3xl font-bold text-white mb-2">{page.title}</h2>
          <div className="text-lg text-gray-300">{page.desc}</div>

          <div className="flex flex-wrap justify-center gap-4">
            <Image
              src="/logo.png"
              alt="Icon"
              width={400}
              height={400}
            />
          </div>
        </div>
      ))} */}
    </div>
  </>
  );
}


Home.getLayout = function getLayout(page: ReactNode) {
  return (
    <HomeContainer>
      {page}
    </HomeContainer>
  )
}
