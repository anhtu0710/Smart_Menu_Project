package com.smartmenu.service;

import com.smartmenu.dto.MenuStyleConfigDto;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class MenuStyleConfigRegistry {

    private final Map<String, MenuStyleConfigDto> registry = new HashMap<>();

    public MenuStyleConfigRegistry() {
        initRegistry();
    }

    private void initRegistry() {
        // 1. HIEN_DAI / MODERN
        registry.put("HIEN_DAI", MenuStyleConfigDto.builder()
                .styleId("HIEN_DAI")
                .styleName("Hiện Đại Thương Mại")
                .referenceImagePath("classpath:/menu-style/HIEN_DAI/reference.png")
                .referenceImages(List.of(
                        "classpath:/menu-style/HIEN_DAI/reference.png",
                        "classpath:/menu-style/HIEN_DAI/sample_2.png"))
                .referenceImagePaths(List.of(
                        "classpath:/menu-style/HIEN_DAI/reference.png",
                        "classpath:/menu-style/HIEN_DAI/sample_2.png"))
                .visualPrompt(
                        "Modern coffee shop menu, clean commercial poster layout, Slate Navy background, cyan glowing accents, professional F&B typography, balanced whitespace")
                .styleGoal("Highlight best sellers and high-profit drinks with clean modern commercial aesthetic")
                .typographyRule("SansSerif sleek modern typography with high contrast price tags")
                .colorRule("Dark Slate Navy canvas #0f172a with electric cyan #38bdf8 accents and amber #f59e0b prices")
                .decorationRule("Subtle glowing cyan accent bars and clean geometric divider lines")
                .compositionRule(
                        "Asymmetrical modern header, large HERO visual banner area, clean CORE text list, promo combo section at bottom")
                .imageMoodRule("High contrast luxury F&B food visual with neon cyan glowing accents")
                .theme("MODERN_SLATE")
                .colorPalette(
                        List.of("#0f172a", "#38bdf8", "#f8fafc", "#f59e0b", "#0284c7", "#1e293b", "#0f172a", "#1e1b4b"))
                .fontStyle("SansSerif")
                .backgroundStyle("DARK_NAVY_SLATE")
                .imageStyle("VECTOR_ILLUSTRATION")
                .decorationLevel("MEDIUM")
                .assetMode("PURE_SVG_DYNAMIC")
                .build());

        registry.put("MODERN", registry.get("HIEN_DAI"));
        registry.put("COFFEE_MODERN_01", registry.get("HIEN_DAI"));

        // 2. SANG_TRONG / LUXURY
        registry.put("SANG_TRONG", MenuStyleConfigDto.builder()
                .styleId("SANG_TRONG")
                .styleName("Sang Trọng Hoàng Gia")
                .referenceImagePath("classpath:/menu-style/SANG_TRONG/reference.png")
                .referenceImages(List.of(
                        "classpath:/menu-style/SANG_TRONG/reference.png",
                        "classpath:/menu-style/SANG_TRONG/sample_2.png"))
                .referenceImagePaths(List.of(
                        "classpath:/menu-style/SANG_TRONG/reference.png",
                        "classpath:/menu-style/SANG_TRONG/sample_2.png"))
                .visualPrompt(
                        "Luxury high-end restaurant menu, dark espresso background, gold 24k typography, royal double border frame, crown crest ornaments, premium fine dining feeling")
                .styleGoal("Create an elegant high-end fine dining luxury restaurant menu")
                .typographyRule("Elegant Serif typography with royal crown header alignment")
                .colorRule("Espresso dark canvas #1c1917 with gold foil #fbbf24 accents and amber #f59e0b highlights")
                .decorationRule("Royal gold metallic double border, crown crest divider, gold star accents")
                .compositionRule(
                        "Centered luxury layout, prominent HERO gold banner, subtle featured cards, elegant core text rows")
                .imageMoodRule("Royal studio food photography with warm gold highlights")
                .theme("LUXURY_ELEGANT")
                .colorPalette(
                        List.of("#1c1917", "#f59e0b", "#fef3c7", "#fbbf24", "#b45309", "#292524", "#1c1917", "#451a03"))
                .fontStyle("Serif")
                .backgroundStyle("DARK_GOLD_LUXURY")
                .imageStyle("VECTOR_ILLUSTRATION")
                .decorationLevel("HIGH")
                .assetMode("PURE_SVG_DYNAMIC")
                .build());

        registry.put("LUXURY", registry.get("SANG_TRONG"));
        registry.put("COFFEE_LUXURY_01", registry.get("SANG_TRONG"));

        // 3. TRUYEN_THONG / VINTAGE
        registry.put("TRUYEN_THONG", MenuStyleConfigDto.builder()
                .styleId("TRUYEN_THONG")
                .styleName("Truyền Thống Cổ Điển")
                .referenceImagePath("classpath:/menu-style/TRUYEN_THONG/reference.png")
                .referenceImages(List.of(
                        "classpath:/menu-style/TRUYEN_THONG/reference.png",
                        "classpath:/menu-style/TRUYEN_THONG/sample_2.png"))
                .referenceImagePaths(List.of(
                        "classpath:/menu-style/TRUYEN_THONG/reference.png",
                        "classpath:/menu-style/TRUYEN_THONG/sample_2.png"))
                .visualPrompt(
                        "Traditional Vietnamese coffee house menu, warm parchment paper background, retro coffee house banner, sepia brown tones, rustic classic atmosphere")
                .styleGoal("Create a vintage classic Vietnamese coffee house parchment menu")
                .typographyRule("Classic Retro Serif typography with warm brown price highlights")
                .colorRule("Warm parchment canvas #fbf0d9 with sepia brown #78350f headers and amber #b45309 accents")
                .decorationRule("Retro double border frame, vintage corner ornaments, coffee bean graphic accents")
                .compositionRule("Classic retro banner header, prominent HERO visual section, clean vintage text list")
                .imageMoodRule("Warm rustic retro food visual on parchment canvas")
                .theme("VINTAGE_CLASSIC")
                .colorPalette(
                        List.of("#fbf0d9", "#78350f", "#451a03", "#b45309", "#d97706", "#fef3c7", "#fbf0d9", "#7c2d12"))
                .fontStyle("Serif")
                .backgroundStyle("WARM_VINTAGE_PARCHMENT")
                .imageStyle("LINE_ART")
                .decorationLevel("HIGH")
                .assetMode("PURE_SVG_DYNAMIC")
                .build());

        registry.put("VINTAGE", registry.get("TRUYEN_THONG"));
        registry.put("COFFEE_TRADITIONAL_01", registry.get("TRUYEN_THONG"));

        // 4. TRE_TRUNG / CUTE
        registry.put("TRE_TRUNG", MenuStyleConfigDto.builder()
                .styleId("TRE_TRUNG")
                .styleName("Trẻ Trung Pastel")
                .referenceImagePath("classpath:/menu-style/TRE_TRUNG/reference.png")
                .referenceImages(List.of(
                        "classpath:/menu-style/TRE_TRUNG/reference.png",
                        "classpath:/menu-style/TRE_TRUNG/sample_2.png"))
                .referenceImagePaths(List.of(
                        "classpath:/menu-style/TRE_TRUNG/reference.png",
                        "classpath:/menu-style/TRE_TRUNG/sample_2.png"))
                .visualPrompt(
                        "Youthful cafe social media style menu, soft pastel pink background, cute rounded pill header, friendly rounded typography, soft pastel cards, playful star accents")
                .styleGoal("Create a playful cute youth cafe menu for social media generation")
                .typographyRule("Friendly rounded SansSerif typography with rose pink price highlights")
                .colorRule(
                        "Soft pastel pink canvas #fff0f5 with deep rose #db2777 headers and soft pink #ffe4e1 card fills")
                .decorationRule("Cute rounded corners rx=32px, pill header rx=26px, star/circle decorative accents")
                .compositionRule("Rounded pill header, cute HERO card container, friendly core text list")
                .imageMoodRule("Soft pastel food photography with warm natural lighting")
                .theme("CUTE_PASTEL")
                .colorPalette(
                        List.of("#fff0f5", "#db2777", "#831843", "#be185d", "#fbcfe8", "#ffe4e1", "#fff0f5", "#fce7f3"))
                .fontStyle("DejaVu Sans")
                .backgroundStyle("PASTEL_CUTE_PINK")
                .imageStyle("VECTOR_ILLUSTRATION")
                .decorationLevel("HIGH")
                .assetMode("PURE_SVG_DYNAMIC")
                .build());

        registry.put("CUTE", registry.get("TRE_TRUNG"));
        registry.put("COFFEE_YOUTHFUL_01", registry.get("TRE_TRUNG"));

        // 5. MINIMAL - Tối Giản Tinh Tế (Scandinavian Minimalist)
        registry.put("MINIMAL", MenuStyleConfigDto.builder()
                .styleId("MINIMAL")
                .styleName("Tối Giản Tinh Tế")
                .referenceImagePath("classpath:/menu-style/MINIMAL/reference.png")
                .referenceImages(List.of(
                        "classpath:/menu-style/MINIMAL/reference.png",
                        "classpath:/menu-style/MINIMAL/sample_1.png"))
                .referenceImagePaths(List.of(
                        "classpath:/menu-style/MINIMAL/reference.png",
                        "classpath:/menu-style/MINIMAL/sample_1.png"))
                .visualPrompt(
                        "Minimalist Scandinavian cafe menu, warm linen cream paper background, elegant serif typography, thin double border frame, gold copper accent corners, clean whitespace, leader-dot price alignment")
                .styleGoal("Create an ultra-clean, elegant minimalist cafe menu with generous whitespace and premium typography")
                .typographyRule("Classic Georgia Serif header with clean SansSerif body, amber-brown price highlights")
                .colorRule("Warm linen canvas #faf8f4 with dark espresso #1e1c1a typography and copper gold #b48c4b accents")
                .decorationRule("Thin double border frame, corner accents, gold diamond divider, subtle leader dots")
                .compositionRule("Centered header, two-column item list, signature combo banner, quality feature boxes")
                .imageMoodRule("Clean studio food portrait with neutral warm background")
                .theme("MINIMAL_SCANDINAVIAN")
                .colorPalette(
                        List.of("#faf8f4", "#1e1c1a", "#b48c4b", "#786040", "#aa4614", "#cdc3b4", "#f6f2eb", "#ede8e0"))
                .fontStyle("Serif")
                .backgroundStyle("WARM_LINEN_CREAM")
                .imageStyle("LINE_ART")
                .decorationLevel("MINIMAL")
                .assetMode("PURE_SVG_DYNAMIC")
                .build());

        // 6. NHIET_DOI - Nhiệt Đới Tươi Mát (Tropical Fresh Bar)
        registry.put("NHIET_DOI", MenuStyleConfigDto.builder()
                .styleId("NHIET_DOI")
                .styleName("Nhiệt Đới Tươi Mát")
                .referenceImagePath("classpath:/menu-style/NHIET_DOI/reference.png")
                .referenceImages(List.of(
                        "classpath:/menu-style/NHIET_DOI/reference.png",
                        "classpath:/menu-style/NHIET_DOI/sample_1.png"))
                .referenceImagePaths(List.of(
                        "classpath:/menu-style/NHIET_DOI/reference.png",
                        "classpath:/menu-style/NHIET_DOI/sample_1.png"))
                .visualPrompt(
                        "Tropical fresh fruit bar menu, deep emerald green forest background, gold amber border frame, botanical leaf silhouettes, mint green and amber typography, vibrant fresh fruit tea and smoothie items")
                .styleGoal("Create a vibrant tropical fresh fruit beverage menu bursting with energy and natural freshness")
                .typographyRule("Bold SansSerif with gold amber category headers and mint green price highlights")
                .colorRule("Deep emerald #052a20 canvas with gold #f59e0b headers and mint #34d399 accents")
                .decorationRule("Rounded card containers, gold amber border, tropical leaf shadow motifs, pill badge labels")
                .compositionRule("Centered logo header, two rounded category cards side by side, summer deal combo, benefit badges")
                .imageMoodRule("Vibrant tropical fruit food photography with lush green botanical background")
                .theme("TROPICAL_FRESH")
                .colorPalette(
                        List.of("#052a20", "#f59e0b", "#fef3c7", "#34d399", "#fbbf24", "#d1fae5", "#052a20", "#0a4634"))
                .fontStyle("SansSerif")
                .backgroundStyle("DARK_TROPICAL_GREEN")
                .imageStyle("VECTOR_ILLUSTRATION")
                .decorationLevel("HIGH")
                .assetMode("PURE_SVG_DYNAMIC")
                .build());

        registry.put("TROPICAL", registry.get("NHIET_DOI"));
        registry.put("FRESH", registry.get("NHIET_DOI"));
    }

    public MenuStyleConfigDto getStyleConfig(String styleId) {
        if (styleId == null || styleId.isBlank()) {
            return registry.get("HIEN_DAI");
        }
        String key = styleId.toUpperCase().trim();
        return registry.getOrDefault(key, registry.get("HIEN_DAI"));
    }
}
