import HomeContainer from "@/components/home-container";
import Link from "next/link";
import { ReactNode, useEffect, useState } from "react";
import { useRouter } from "next/router";
import { FaChevronDown, FaTerminal } from "react-icons/fa";
import Head from "next/head";

interface FAQItem {
	id: string;
	question: string;
	answer: ReactNode;
}

const faqs: FAQItem[] = [
	{
		id: "install",
		question: "How do I install MewNotch?",
		answer: (
			<div className="space-y-4">
				<ol className="list-decimal list-inside space-y-2 marker:text-blue-500 font-medium text-gray-700 dark:text-gray-200">
					<li>Download the latest <code>.dmg</code> file from <a href="https://github.com/monuk7735/mew-notch/releases" target="_blank" rel="noopener noreferrer" className="text-blue-500 hover:underline">GitHub Releases</a>.</li>
					<li>Open the downloaded file and drag <strong>MewNotch</strong> into your <strong>Applications</strong> folder.</li>
					<li>Double-click the app to open it.</li>
				</ol>

				<div className="bg-yellow-50 dark:bg-yellow-900/20 border border-yellow-200 dark:border-yellow-900/50 p-4 rounded-lg space-y-4">
					<p className="text-sm text-yellow-900 dark:text-yellow-100 font-semibold">
						⚠️ &quot;Damaged&quot; or &quot;Unidentified Developer&quot; Error?
					</p>

					<div>
						<p className="text-sm text-yellow-800 dark:text-yellow-200 mb-2">
							<strong>Option 1 (Recommended):</strong> Allow via System Settings
						</p>
						<ul className="list-disc list-inside text-sm text-yellow-800/90 dark:text-yellow-200/90 space-y-1 ml-1">
							<li>Open <strong>System Settings</strong> → <strong>Privacy & Security</strong>.</li>
							<li>Scroll down to the <strong>Security</strong> section.</li>
							<li>Look for &quot;MewNotch was blocked...&quot; and click <strong>Open Anyway</strong>.</li>
							<li>Click <strong>Open</strong> in the confirmation popup.</li>
						</ul>
					</div>

					<div className="pt-3 border-t border-yellow-200 dark:border-yellow-900/30">
						<p className="text-sm text-yellow-800 dark:text-yellow-200 mb-2">
							<strong>Option 2 (Advanced):</strong> Run this command in Terminal
						</p>
						<div className="bg-gray-900 text-gray-100 p-3 rounded-md font-mono text-xs md:text-sm overflow-x-auto flex items-center gap-3 shadow-inner">
							<FaTerminal className="text-gray-500 flex-shrink-0" />
							<code>xattr -cr /Applications/MewNotch.app</code>
						</div>
						<div className="text-xs text-yellow-800/80 dark:text-yellow-200/70 mt-3 space-y-1">
							<p className="text-xs text-yellow-700/70 dark:text-yellow-300/60 italic">
								This command simply removes the &quot;quarantine&quot; flag that macOS places on apps downloaded from the internet, resolving the false error.
							</p>
							<p><code className="font-bold">xattr</code> : The utility to modify file attributes.</p>
							<p><code className="font-bold">-c</code> : Clears all attributes (removes the &quot;quarantine&quot; flag).</p>
							<p><code className="font-bold">-r</code> : Recursive (applies to all files inside the app bundle).</p>
						</div>
					</div>
				</div>
			</div>
		),
	},
	{
		id: "supported-devices",
		question: "Which MacBooks are supported?",
		answer: (
			<span>
				MewNotch is designed specifically for <strong>MacBooks with a notch</strong> (M1/M2/M3 Pro & Air models).
				<br /><br />
				It <em>can</em> run on older Macs or external displays, but the overlay might cover your menu bar icons since it&apos;s meant to sit in the &quot;dead space&quot; of the notch.
			</span>
		),
	},
	{
		id: "customization",
		question: "Can I customize what appears in the notch?",
		answer: (
			<span>
				<strong>Yes!</strong> You have full control. In the app settings, you can toggle specific indicators (like Battery, Volume, Brightness) on or off and adjust their visual style to match your preference.
			</span>
		),
	},
	{
		id: "privacy",
		question: "Does MewNotch collect any data?",
		answer: (
			<span>
				<strong>No. Never.</strong> MewNotch does not collect, track, or share <em>any</em> personal data. It runs entirely offline on your device. Your privacy is paramount.
			</span>
		),
	},
	{
		id: "free",
		question: "Is it really free?",
		answer: (
			<span>
				<strong>100% Free & Open Source.</strong> No ads, no paywalls, no &quot;Pro&quot; version.
				<br />
				If you love the app, you can <Link href="/support" className="text-blue-500 hover:underline font-medium">support the project</Link> voluntarily, but it&apos;s never required.
			</span>
		),
	},
	{
		id: "bugs",
		question: "I found a bug! What should I do?",
		answer: (
			<span>
				Please open an issue on the <a href="https://github.com/monuk7735/mew-notch/issues" target="_blank" rel="noopener noreferrer" className="text-blue-500 hover:underline font-medium">GitHub repository</a>.
				<br />
				Detailed reports (screenshots, steps to reproduce) help me fix things faster!
			</span>
		),
	},
	{
		id: "features",
		question: "Will there be more features?",
		answer: (
			<span>
				<strong>Yes!</strong> New features are actively planned.
				<br />
				Have a cool idea? Submit a feature request on <a href="https://github.com/monuk7735/mew-notch" target="_blank" rel="noopener noreferrer" className="text-blue-500 hover:underline font-medium">GitHub</a> to help shape the future of MewNotch.
			</span>
		),
	},
];

function Accordion({ faqs }: { faqs: FAQItem[] }) {
	const router = useRouter();
	const [openIdx, setOpenIdx] = useState<number | null>(null);

	useEffect(() => {
		if (!router.isReady) return;
		const { q } = router.query;
		if (q) {
			const index = faqs.findIndex((f) => f.id === q);
			if (index !== -1) {
				setOpenIdx(index);
				// Small delay to ensure render
				setTimeout(() => {
					const el = document.getElementById(`faq-${index}`);
					if (el) {
						el.scrollIntoView({ behavior: "smooth", block: "center" });
						// Add a temporary highlight effect
						el.classList.add("ring-2", "ring-blue-500", "ring-offset-2");
						setTimeout(() => el.classList.remove("ring-2", "ring-blue-500", "ring-offset-2"), 2000);
					}
				}, 300);
			}
		}
	}, [router.isReady, router.query, faqs]);

	return (
		<div className="w-full max-w-3xl mx-auto flex flex-col gap-4">
			{faqs.map((faq, idx) => (
				<div
					key={idx}
					id={`faq-${idx}`}
					className={`group rounded-2xl border transition-all duration-200 ${openIdx === idx
						? "bg-white dark:bg-gray-800 border-blue-200 dark:border-blue-900 shadow-md"
						: "bg-white/50 dark:bg-gray-800/30 border-gray-200 dark:border-gray-700 hover:border-blue-300 dark:hover:border-blue-700"
						}`}
				>
					<button
						id={`faq-btn-${idx}`}
						className="w-full flex items-center justify-between p-6 text-left focus:outline-none"
						onClick={() => setOpenIdx(openIdx === idx ? null : idx)}
						aria-expanded={openIdx === idx}
						aria-controls={`faq-content-${idx}`}
					>
						<span className={`text-lg font-semibold transition-colors ${openIdx === idx ? "text-blue-600 dark:text-blue-400" : "text-gray-900 dark:text-white"}`}>
							{faq.question}
						</span>
						<span className={`ml-4 p-2 rounded-full transition-all duration-300 ${openIdx === idx ? "bg-blue-100 dark:bg-blue-900/30 rotate-180" : "bg-gray-100 dark:bg-gray-700 group-hover:bg-blue-50 dark:group-hover:bg-blue-900/20"}`}>
							<FaChevronDown
								className={`text-sm transition-colors ${openIdx === idx ? "text-blue-600 dark:text-blue-400" : "text-gray-500 dark:text-gray-400"}`}
							/>
						</span>
					</button>

					<div
						id={`faq-content-${idx}`}
						role="region"
						aria-labelledby={`faq-btn-${idx}`}
						className={`grid overflow-hidden transition-all duration-300 ease-in-out ${openIdx === idx ? "grid-rows-[1fr] opacity-100" : "grid-rows-[0fr] opacity-0"}`}
					>
						<div className="overflow-hidden min-h-0">
							<div className="px-6 pb-6 pt-0 text-gray-600 dark:text-gray-300 leading-relaxed">
								{faq.answer}
							</div>
						</div>
					</div>
				</div>
			))}
		</div>
	);
}

export default function FAQ() {
	return (
		<>
			<Head>
				<title>FAQ - MewNotch</title>
			</Head>
			<div className="flex flex-col items-center min-h-[80vh] px-6 py-20 w-full">
				<div className="text-center space-y-4 mb-12">
					<h1 className="text-4xl md:text-5xl font-bold text-gray-900 dark:text-white">
						Frequently Asked Questions
					</h1>
					<p className="text-xl text-gray-600 dark:text-gray-300">
						Everything you need to know about MewNotch.
					</p>
				</div>

				<Accordion faqs={faqs} />
			</div>
		</>
	);
}

FAQ.getLayout = function getLayout(page: ReactNode) {
	return <HomeContainer>{page}</HomeContainer>;
};
