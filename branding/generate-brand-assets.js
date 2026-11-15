const fs = require('fs');
const path = require('path');

const BRAND_DIR = __dirname;
const LOGO_DIR = path.join(BRAND_DIR, 'logo', 'variants');
const WALLPAPER_DIR = path.join(BRAND_DIR, 'wallpapers');

[LOGO_DIR, WALLPAPER_DIR].forEach(dir => {
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
});

// Common definitions for the faceted R emblem
function getREmblem(options = {}) {
  const {
    idPrefix = 'r',
    primaryColor1 = '#C4B5FD',
    primaryColor2 = '#A78BFA',
    primaryColor3 = '#8B5CF6',
    primaryColor4 = '#6D28D9',
    accentStar = '#FFFFFF',
    stroke = 'none',
    strokeWidth = 0
  } = options;

  return `
    <defs>
      <linearGradient id="${idPrefix}_top" x1="0%" y1="0%" x2="100%" y2="100%">
        <stop offset="0%" stop-color="${primaryColor1}" />
        <stop offset="100%" stop-color="${primaryColor2}" />
      </linearGradient>
      <linearGradient id="${idPrefix}_stem" x1="0%" y1="0%" x2="0%" y2="100%">
        <stop offset="0%" stop-color="${primaryColor2}" />
        <stop offset="100%" stop-color="${primaryColor4}" />
      </linearGradient>
      <linearGradient id="${idPrefix}_loop" x1="0%" y1="0%" x2="100%" y2="100%">
        <stop offset="0%" stop-color="${primaryColor1}" />
        <stop offset="100%" stop-color="${primaryColor3}" />
      </linearGradient>
      <linearGradient id="${idPrefix}_leg" x1="0%" y1="0%" x2="100%" y2="100%">
        <stop offset="0%" stop-color="${primaryColor2}" />
        <stop offset="100%" stop-color="${primaryColor4}" />
      </linearGradient>
      <filter id="${idPrefix}_glow" x="-20%" y="-20%" width="140%" height="140%">
        <feGaussianBlur stdDeviation="8" result="blur" />
        <feComposite in="SourceGraphic" in2="blur" operator="over" />
      </filter>
    </defs>

    <!-- Faceted Modern 'R' Geometry -->
    <g stroke="${stroke}" stroke-width="${strokeWidth}" stroke-linejoin="round">
      <!-- Left Stem -->
      <polygon points="40,30 90,30 90,210 40,210" fill="url(#${idPrefix}_stem)" />
      
      <!-- Top Arc/Loop Outer -->
      <path d="M 90,30 L 160,30 C 195,30 220,55 220,88 C 220,120 195,142 160,142 L 90,142 Z" fill="url(#${idPrefix}_loop)" />
      
      <!-- Loop Inner Cutout (Dark Surface) -->
      <path d="M 90,65 L 145,65 C 165,65 178,75 178,88 C 178,102 165,110 145,110 L 90,110 Z" fill="#080B16" />

      <!-- Diagonal Dynamic Leg -->
      <polygon points="120,132 170,132 230,210 175,210" fill="url(#${idPrefix}_leg)" />

      <!-- Top Left Facet Chamfer / Glow Highlight -->
      <polygon points="35,30 65,10 90,30 40,30" fill="url(#${idPrefix}_top)" />

      <!-- Sparkle Star at Top Crest -->
      <g transform="translate(68, 22) scale(0.85)">
        <path d="M 0,-16 Q 0,0 16,0 Q 0,0 0,16 Q 0,0 -16,0 Q 0,0 0,-16 Z" fill="${accentStar}" filter="url(#${idPrefix}_glow)" />
      </g>
    </g>
  `;
}

// 1. Primary RevoltOS Logo (Icon + Wordmark + Tagline)
const logoPrimary = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 240" width="800" height="240">
  <rect width="100%" height="100%" fill="transparent" />
  <g transform="translate(20, 0)">
    ${getREmblem({ idPrefix: 'pri' })}
    <text x="260" y="130" font-family="'Inter', -apple-system, sans-serif" font-size="78" font-weight="900" letter-spacing="-1" fill="#F8FAFC">
      Revolt<tspan fill="#8B5CF6">OS</tspan>
    </text>
    <text x="265" y="175" font-family="'Inter', -apple-system, sans-serif" font-size="24" font-weight="500" letter-spacing="8" fill="#A78BFA">
      BEYOND LIMITS.
    </text>
  </g>
</svg>
`;

// 2. Standalone R Symbol
const logoStandaloneR = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 260 240" width="260" height="240">
  ${getREmblem({ idPrefix: 'std' })}
</svg>
`;

// 3. White Logo (Pure White for Dark Media)
const logoWhite = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 240" width="800" height="240">
  <g transform="translate(20, 0)">
    ${getREmblem({
      idPrefix: 'wh',
      primaryColor1: '#FFFFFF',
      primaryColor2: '#F1F5F9',
      primaryColor3: '#E2E8F0',
      primaryColor4: '#CBD5E1',
      accentStar: '#FFFFFF'
    })}
    <text x="260" y="130" font-family="'Inter', sans-serif" font-size="78" font-weight="900" fill="#FFFFFF">
      RevoltOS
    </text>
    <text x="265" y="175" font-family="'Inter', sans-serif" font-size="24" font-weight="500" letter-spacing="8" fill="#E2E8F0">
      BEYOND LIMITS.
    </text>
  </g>
</svg>
`;

// 4. Black Logo (for Light Documents)
const logoBlack = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 240" width="800" height="240">
  <g transform="translate(20, 0)">
    ${getREmblem({
      idPrefix: 'blk',
      primaryColor1: '#334155',
      primaryColor2: '#1E293B',
      primaryColor3: '#0F172A',
      primaryColor4: '#020617',
      accentStar: '#000000'
    })}
    <text x="260" y="130" font-family="'Inter', sans-serif" font-size="78" font-weight="900" fill="#0F172A">
      RevoltOS
    </text>
    <text x="265" y="175" font-family="'Inter', sans-serif" font-size="24" font-weight="500" letter-spacing="8" fill="#475569">
      BEYOND LIMITS.
    </text>
  </g>
</svg>
`;

// 5. Purple Accent Logo
const logoPurple = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 240" width="800" height="240">
  <g transform="translate(20, 0)">
    ${getREmblem({
      idPrefix: 'pur',
      primaryColor1: '#E9D5FF',
      primaryColor2: '#C084FC',
      primaryColor3: '#9333EA',
      primaryColor4: '#6B21A8',
      accentStar: '#FAF5FF'
    })}
    <text x="260" y="130" font-family="'Inter', sans-serif" font-size="78" font-weight="900" fill="#9333EA">
      Revolt<tspan fill="#C084FC">OS</tspan>
    </text>
    <text x="265" y="175" font-family="'Inter', sans-serif" font-size="24" font-weight="600" letter-spacing="8" fill="#7E22CE">
      BEYOND LIMITS.
    </text>
  </g>
</svg>
`;

// 6. Monochrome Logo
const logoMonochrome = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 240" width="800" height="240">
  <g transform="translate(20, 0)">
    ${getREmblem({
      idPrefix: 'mono',
      primaryColor1: '#CCCCCC',
      primaryColor2: '#888888',
      primaryColor3: '#666666',
      primaryColor4: '#444444',
      accentStar: '#EEEEEE'
    })}
    <text x="260" y="130" font-family="'Inter', sans-serif" font-size="78" font-weight="900" fill="#CCCCCC">
      RevoltOS
    </text>
    <text x="265" y="175" font-family="'Inter', sans-serif" font-size="24" font-weight="500" letter-spacing="8" fill="#888888">
      BEYOND LIMITS.
    </text>
  </g>
</svg>
`;

// 7. Application Icon (Squircle container with glow)
const logoAppIcon = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="256" height="256">
  <defs>
    <linearGradient id="sq_bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#191F31" />
      <stop offset="100%" stop-color="#080B16" />
    </linearGradient>
    <filter id="app_glow" x="-20%" y="-20%" width="140%" height="140%">
      <feGaussianBlur stdDeviation="10" result="blur" />
      <feComposite in="SourceGraphic" in2="blur" operator="over" />
    </filter>
  </defs>
  <rect x="8" y="8" width="240" height="240" rx="56" fill="url(#sq_bg)" stroke="#8B5CF6" stroke-width="2.5" stroke-opacity="0.6" />
  <g transform="translate(14, 12) scale(0.92)">
    ${getREmblem({ idPrefix: 'app' })}
  </g>
</svg>
`;

// 8. Boot Splash Logo
const logoBootSplash = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 400" width="600" height="400">
  <rect width="100%" height="100%" fill="#080B16" />
  <g transform="translate(180, 50) scale(0.95)">
    ${getREmblem({ idPrefix: 'boot' })}
  </g>
  <text x="300" y="300" text-anchor="middle" font-family="'Inter', sans-serif" font-size="44" font-weight="800" fill="#F8FAFC">
    Revolt<tspan fill="#8B5CF6">OS</tspan>
  </text>
  <text x="300" y="340" text-anchor="middle" font-family="'Inter', sans-serif" font-size="16" font-weight="500" letter-spacing="6" fill="#A78BFA">
    BEYOND LIMITS.
  </text>
</svg>
`;

// 9. Installer Logo
const logoInstaller = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 500 120" width="500" height="120">
  <g transform="translate(10, 0) scale(0.5)">
    ${getREmblem({ idPrefix: 'inst' })}
  </g>
  <text x="145" y="65" font-family="'Inter', sans-serif" font-size="38" font-weight="800" fill="#F8FAFC">
    RevoltOS <tspan fill="#8B5CF6" font-size="24" font-weight="400">Installer</tspan>
  </text>
  <text x="148" y="92" font-family="'Inter', sans-serif" font-size="14" font-weight="500" letter-spacing="4" fill="#9299AA">
    BEYOND LIMITS.
  </text>
</svg>
`;

// 10. Wallpaper Watermark
const logoWatermark = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 100" width="400" height="100">
  <g opacity="0.35">
    <g transform="translate(10, 0) scale(0.42)">
      ${getREmblem({ idPrefix: 'wm', primaryColor1: '#FFFFFF', primaryColor2: '#A78BFA', primaryColor3: '#8B5CF6', primaryColor4: '#6D28D9' })}
    </g>
    <text x="120" y="55" font-family="'Inter', sans-serif" font-size="32" font-weight="800" fill="#FFFFFF">
      RevoltOS
    </text>
    <text x="122" y="78" font-family="'Inter', sans-serif" font-size="12" font-weight="500" letter-spacing="4" fill="#A78BFA">
      v1.0.0 BETA
    </text>
  </g>
</svg>
`;

// Write all 10 logo variations
const logos = {
  'revoltos-logo-primary.svg': logoPrimary,
  'revoltos-symbol-r.svg': logoStandaloneR,
  'revoltos-logo-white.svg': logoWhite,
  'revoltos-logo-black.svg': logoBlack,
  'revoltos-logo-purple.svg': logoPurple,
  'revoltos-logo-monochrome.svg': logoMonochrome,
  'revoltos-app-icon.svg': logoAppIcon,
  'revoltos-bootsplash.svg': logoBootSplash,
  'revoltos-installer.svg': logoInstaller,
  'revoltos-watermark.svg': logoWatermark
};

Object.entries(logos).forEach(([filename, content]) => {
  fs.writeFileSync(path.join(LOGO_DIR, filename), content.trim());
  console.log(`[+] Created Logo Variant: ${filename}`);
});

// Also update default branding/logo/revoltos-logo.svg
fs.writeFileSync(path.join(BRAND_DIR, 'logo', 'revoltos-logo.svg'), logoPrimary.trim());

// ==========================================
// 5 WALLPAPERS (4K UHD 3840x2160)
// ==========================================

// Wallpaper 1: Beyond Limits (Futuristic Cosmic Purple Ring over Mountains & Lake Reflection)
const wallpaperBeyondLimits = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3840 2160" width="3840" height="2160">
  <defs>
    <linearGradient id="skyGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#04050a" />
      <stop offset="35%" stop-color="#140b2b" />
      <stop offset="65%" stop-color="#28114b" />
      <stop offset="90%" stop-color="#4c1d95" />
      <stop offset="100%" stop-color="#6d28d9" />
    </linearGradient>
    <radialGradient id="ringGlow" cx="50%" cy="50%" r="50%">
      <stop offset="0%" stop-color="#c4b5fd" stop-opacity="0.9" />
      <stop offset="50%" stop-color="#8b5cf6" stop-opacity="0.4" />
      <stop offset="100%" stop-color="#2e1065" stop-opacity="0" />
    </radialGradient>
    <radialGradient id="planetGlow" cx="45%" cy="40%" r="60%">
      <stop offset="0%" stop-color="#e9d5ff" />
      <stop offset="40%" stop-color="#a855f7" />
      <stop offset="75%" stop-color="#581c87" />
      <stop offset="100%" stop-color="#090514" />
    </radialGradient>
    <linearGradient id="lakeGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#1e0c38" />
      <stop offset="40%" stop-color="#0f071e" />
      <stop offset="100%" stop-color="#05030a" />
    </linearGradient>
    <filter id="softGlow" x="-20%" y="-20%" width="140%" height="140%">
      <feGaussianBlur stdDeviation="40" result="blur" />
      <feComposite in="SourceGraphic" in2="blur" operator="over" />
    </filter>
  </defs>

  <!-- Sky -->
  <rect width="3840" height="1500" fill="url(#skyGrad)" />

  <!-- Stars -->
  <g fill="#FFFFFF" opacity="0.7">
    <circle cx="450" cy="220" r="2.5" />
    <circle cx="820" cy="140" r="1.5" />
    <circle cx="1250" cy="310" r="2" />
    <circle cx="1780" cy="180" r="3" />
    <circle cx="2150" cy="280" r="1.5" />
    <circle cx="2640" cy="190" r="2.5" />
    <circle cx="3100" cy="340" r="1.5" />
    <circle cx="3480" cy="150" r="2" />
  </g>

  <!-- Cosmic Celestial Sphere (The Purple Moon / Ring) -->
  <circle cx="1920" cy="880" r="540" fill="url(#planetGlow)" opacity="0.95" />
  <circle cx="1920" cy="880" r="560" fill="none" stroke="#C4B5FD" stroke-width="6" opacity="0.6" filter="url(#softGlow)" />
  <ellipse cx="1920" cy="900" rx="720" ry="80" fill="none" stroke="#A78BFA" stroke-width="4" opacity="0.4" transform="rotate(-12 1920 900)" />

  <!-- Mountain Silhouettes -->
  <!-- Distant Range -->
  <polygon points="0,1520 420,1180 860,1380 1340,1120 1920,1350 2500,1080 3050,1360 3540,1190 3840,1480 3840,1650 0,1650" fill="#120826" />
  
  <!-- Mid Range (Purple Rimlit) -->
  <polygon points="0,1580 580,1260 1150,1460 1620,1280 2150,1480 2740,1220 3380,1490 3840,1340 3840,1720 0,1720" fill="#180a33" />
  
  <!-- Foreground Ridge -->
  <polygon points="0,1680 720,1420 1480,1620 2200,1380 2950,1640 3840,1460 3840,2160 0,2160" fill="#0b0517" />

  <!-- Calm Lake Surface with Cosmic Reflections -->
  <rect y="1620" width="3840" height="540" fill="url(#lakeGrad)" opacity="0.88" />
  <ellipse cx="1920" cy="1820" rx="380" ry="120" fill="#8B5CF6" opacity="0.18" filter="url(#softGlow)" />
  <ellipse cx="1920" cy="1900" rx="220" ry="60" fill="#C4B5FD" opacity="0.12" filter="url(#softGlow)" />
</svg>
`;

// Wallpaper 2: Midnight Horizon (Deep Space Navy with Minimal Geometric Horizon Glow)
const wallpaperMidnightHorizon = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3840 2160" width="3840" height="2160">
  <defs>
    <radialGradient id="navyCenter" cx="50%" cy="55%" r="65%">
      <stop offset="0%" stop-color="#161c33" />
      <stop offset="45%" stop-color="#0b0e1b" />
      <stop offset="100%" stop-color="#04060d" />
    </radialGradient>
    <linearGradient id="horizonGlow" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#080B16" stop-opacity="0" />
      <stop offset="35%" stop-color="#8B5CF6" stop-opacity="0.4" />
      <stop offset="50%" stop-color="#C4B5FD" stop-opacity="0.8" />
      <stop offset="65%" stop-color="#8B5CF6" stop-opacity="0.4" />
      <stop offset="100%" stop-color="#080B16" stop-opacity="0" />
    </linearGradient>
  </defs>
  <rect width="3840" height="2160" fill="url(#navyCenter)" />
  <line x1="0" y1="1260" x2="3840" y2="1260" stroke="url(#horizonGlow)" stroke-width="4" />
  <polygon points="600,1260 1920,860 3240,1260 1920,1660" fill="none" stroke="#8B5CF6" stroke-width="1.5" stroke-opacity="0.2" />
</svg>
`;

// Wallpaper 3: Digital Flow (Abstract Cyber Polygonal Mesh)
const wallpaperDigitalFlow = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3840 2160" width="3840" height="2160">
  <defs>
    <linearGradient id="flowGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#080B16" />
      <stop offset="50%" stop-color="#191336" />
      <stop offset="100%" stop-color="#05060d" />
    </linearGradient>
  </defs>
  <rect width="3840" height="2160" fill="url(#flowGrad)" />
  <g fill="none" stroke="#8B5CF6" stroke-width="2" stroke-opacity="0.25">
    <path d="M 0,600 C 600,800 1200,400 1800,700 C 2400,1000 3000,500 3840,800" />
    <path d="M 0,750 C 600,950 1200,550 1800,850 C 2400,1150 3000,650 3840,950" />
    <path d="M 0,900 C 600,1100 1200,700 1800,1000 C 2400,1300 3000,800 3840,1100" />
    <path d="M 0,1050 C 600,1250 1200,850 1800,1150 C 2400,1450 3000,950 3840,1250" />
  </g>
</svg>
`;

// Wallpaper 4: Purple Nebula (Atmospheric Space Dust)
const wallpaperPurpleNebula = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3840 2160" width="3840" height="2160">
  <defs>
    <radialGradient id="neb1" cx="30%" cy="40%" r="50%">
      <stop offset="0%" stop-color="#6d28d9" stop-opacity="0.35" />
      <stop offset="100%" stop-color="#080B16" stop-opacity="0" />
    </radialGradient>
    <radialGradient id="neb2" cx="70%" cy="60%" r="55%">
      <stop offset="0%" stop-color="#8b5cf6" stop-opacity="0.3" />
      <stop offset="100%" stop-color="#080B16" stop-opacity="0" />
    </radialGradient>
  </defs>
  <rect width="3840" height="2160" fill="#080B16" />
  <rect width="3840" height="2160" fill="url(#neb1)" />
  <rect width="3840" height="2160" fill="url(#neb2)" />
</svg>
`;

// Wallpaper 5: Minimal Geometry
const wallpaperMinimalGeometry = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3840 2160" width="3840" height="2160">
  <rect width="3840" height="2160" fill="#080B16" />
  <g fill="none" stroke="#8B5CF6" stroke-width="1.5" stroke-opacity="0.18">
    <polygon points="1920,480 2560,1080 1920,1680 1280,1080" />
    <polygon points="1920,680 2360,1080 1920,1480 1480,1080" />
    <circle cx="1920" cy="1080" r="180" stroke="#A78BFA" stroke-opacity="0.3" />
  </g>
</svg>
`;

const wallpapers = {
  'revoltos-beyond-limits-3840x2160.svg': wallpaperBeyondLimits,
  'revoltos-midnight-horizon-3840x2160.svg': wallpaperMidnightHorizon,
  'revoltos-digital-flow-3840x2160.svg': wallpaperDigitalFlow,
  'revoltos-purple-nebula-3840x2160.svg': wallpaperPurpleNebula,
  'revoltos-minimal-geometry-3840x2160.svg': wallpaperMinimalGeometry,
  'revoltos-wallpaper.svg': wallpaperBeyondLimits // default wallpaper
};

Object.entries(wallpapers).forEach(([filename, content]) => {
  fs.writeFileSync(path.join(WALLPAPER_DIR, filename), content.trim());
  console.log(`[+] Created Wallpaper: ${filename}`);
});

console.log('\\n[SUCCESS] Generated all 10 Logo Variations and 5 UHD Wallpapers.');
