import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.geom.RoundRectangle2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.util.Random;

public class TestYouthfulBlender {

    public static void main(String[] args) throws Exception {
        File srcFile = new File("d:/Smart_Menu/backend/src/main/resources/menu-style/TRE_TRUNG/reference.png");
        BufferedImage canvas = ImageIO.read(srcFile);

        Graphics2D g2d = canvas.createGraphics();
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2d.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
        g2d.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        g2d.setRenderingHint(RenderingHints.KEY_FRACTIONALMETRICS, RenderingHints.VALUE_FRACTIONALMETRICS_ON);

        // =========================================================================
        // 1. TẨY SẠCH 100% TOÀN BỘ TEXT CŨ BẰNG CÁC KHỐI INPAINT THÔNG MINH
        // =========================================================================
        // Cột Cà phê & Trà trái cây cũ + cột giá M L ở giữa
        inpaintIvoryColumn(canvas, 345, 10, 260, 840);

        // Khối Trà sữa cũ (tránh ly trà sữa góc trên phải X>1110 & Y<160)
        inpaintIvoryColumn(canvas, 670, 10, 440, 470);
        inpaintIvoryColumn(canvas, 1110, 160, 110, 320);

        // Khối Đá xay cũ
        inpaintIvoryColumn(canvas, 610, 480, 450, 330);

        // Khối Thức uống khác cũ
        inpaintIvoryColumn(canvas, 590, 810, 515, 270);

        // Patch nhỏ xóa chữ "M" còn sót góc trên phải và chữ tích cực cạnh ly đá xay
        inpaintIvoryColumn(canvas, 875, 100, 30, 30);
        inpaintIvoryColumn(canvas, 860, 625, 75, 30);
        inpaintIvoryColumn(canvas, 595, 405, 15, 60);

        // =========================================================================
        // 2. BRAND CARD GÓC TRÊN TRÁI (Che 100% chữ cũ "GOOD Coffee GOOD Mood")
        // =========================================================================
        renderBrandHeaderCard(g2d, 16, 16, 326, 450,
                "SWEET CORNER CAFE",
                "♡ Tươi mát mỗi ngày • Thơm ngon từng khoảnh khắc ♡",
                "Thực đơn chọn lọc từ hạt cà phê và trà hảo hạng");

        // =========================================================================
        // 3. RENDER 5 DANH MỤC THẬT VỚI TYPOGRAPHY SẮC NÉT, MÀU SẮC TRẺ TRUNG
        // =========================================================================
        // Danh mục 1 (Cột 1 Trên): CÀ PHÊ PHIN & ESPRESSO (đặt tại X: 355)
        renderCategoryCard(g2d, "✿ CÀ PHÊ PHIN & ESPRESSO", 355, 30, 250, new String[][]{
                {"Cà phê đen đá", "25.000đ", "HERO"},
                {"Cà phê sữa đá Sài Gòn", "29.000đ", "HERO"},
                {"Bạc xỉu 3 tầng kem sữa", "32.000đ", ""},
                {"Cà phê muối béo ngậy", "35.000đ", "GIFT"},
                {"Latte cốt dừa nướng", "39.000đ", ""},
                {"Americano bưởi hồng", "35.000đ", ""},
                {"Caramel Macchiato", "42.000đ", ""}
        }, new Color(225, 29, 72), new Color(255, 241, 242));

        // Danh mục 2 (Cột 2 Trên): TRÀ SỮA ĐẬM VỊ (đặt tại X: 685)
        renderCategoryCard(g2d, "✿ TRÀ SỮA ĐẬM VỊ", 685, 30, 290, new String[][]{
                {"Trà sữa truyền thống nướng", "30.000đ", "HERO"},
                {"Trà sữa Thái xanh thạch dừa", "32.000đ", ""},
                {"Trà sữa socola hạt phỉ", "35.000đ", ""},
                {"Trà sữa ô long nướng", "35.000đ", "GIFT"},
                {"Trà sữa trân châu đường đen", "38.000đ", "HERO"},
                {"Trà sữa kem cheese béo", "39.000đ", ""},
                {"Trà sữa khoai môn dẻo", "35.000đ", ""}
        }, new Color(47, 133, 90), new Color(240, 253, 244));

        // Danh mục 3 (Cột 1 Dưới): TRÀ TRÁI CÂY TƯƠI (đặt tại X: 355)
        renderCategoryCard(g2d, "✿ TRÀ TRÁI CÂY TƯƠI", 355, 495, 250, new String[][]{
                {"Trà đào cam sả hạt chia", "35.000đ", "HERO"},
                {"Trà dâu tằm tuyết nhĩ", "38.000đ", "GIFT"},
                {"Trà xoài nhiệt đới chanh dây", "39.000đ", ""},
                {"Trà chanh hoa đậu biếc", "30.000đ", ""},
                {"Trà vải thiều thanh mát", "35.000đ", ""},
                {"Trà tắc xí muội giải nhiệt", "32.000đ", ""}
        }, new Color(234, 88, 12), new Color(255, 247, 237));

        // Danh mục 4 (Cột 2 Giữa): ĐÁ XAY & MATCHA (đặt tại X: 685)
        renderCategoryCard(g2d, "✿ ĐÁ XAY & MATCHA", 685, 495, 290, new String[][]{
                {"Matcha đá xay kem tuyết", "45.000đ", "HERO"},
                {"Cookies đá xay socola", "45.000đ", "HERO"},
                {"Caramel đá xay hạnh nhân", "48.000đ", ""},
                {"Dâu tây đá xay sữa chua", "45.000đ", "GIFT"},
                {"Matcha latte Nhật Bản", "42.000đ", ""}
        }, new Color(37, 99, 235), new Color(239, 246, 255));

        // Danh mục 5 (Cột 2 Dưới): SIGNATURE & NƯỚC ÉP (đặt tại X: 685)
        renderCategoryCard(g2d, "✿ SIGNATURE ĐẶC BIỆT", 685, 745, 290, new String[][]{
                {"Cold Brew cam vàng mật ong", "45.000đ", "HERO"},
                {"Nước ép cam nha đam tươi", "35.000đ", ""},
                {"Nước ép ổi hồng trân châu", "35.000đ", "GIFT"},
                {"Sữa chua dẻo hạt lựu đỏ", "38.000đ", ""}
        }, new Color(168, 85, 247), new Color(250, 245, 255));

        g2d.dispose();

        File outFile = new File("d:/Smart_Menu/backend/test_youthful_clean_100.png");
        ImageIO.write(canvas, "png", outFile);
        System.out.println("Output saved to: " + outFile.getAbsolutePath());
    }

    private static void inpaintIvoryColumn(BufferedImage canvas, int x, int y, int w, int h) {
        Graphics2D g2d = canvas.createGraphics();
        Random rnd = new Random(42);

        BufferedImage patch = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);

        for (int py = 0; py < h; py++) {
            float vProg = (float) py / h;
            for (int px = 0; px < w; px++) {
                float hProg = (float) px / w;

                // Tone màu kem tự nhiên của nền menu
                int baseR = (int) (239 - 5 * vProg + 2 * hProg);
                int baseG = (int) (225 - 6 * vProg + 1 * hProg);
                int baseB = (int) (208 - 5 * vProg + 1 * hProg);

                int noise = rnd.nextInt(7) - 3;
                int r = Math.min(255, Math.max(0, baseR + noise));
                int g = Math.min(255, Math.max(0, baseG + noise));
                int b = Math.min(255, Math.max(0, baseB + noise));

                // Feather biên để hòa lẫn hoàn toàn vào ảnh gốc
                int alpha = 255;
                int edgeDistX = Math.min(px, w - 1 - px);
                int edgeDistY = Math.min(py, h - 1 - py);
                int edgeDist = Math.min(edgeDistX, edgeDistY);
                if (edgeDist < 8) {
                    alpha = (int) (255 * (edgeDist / 8.0f));
                }

                int argb = (alpha << 24) | (r << 16) | (g << 8) | b;
                patch.setRGB(px, py, argb);
            }
        }

        g2d.drawImage(patch, x, y, null);
        g2d.dispose();
    }

    private static void renderBrandHeaderCard(Graphics2D g2d, int x, int y, int w, int h, String brandName, String slogan, String desc) {
        // Nền card bo tròn màu kem trắng sang trọng viền hồng pastel
        g2d.setColor(new Color(255, 252, 248, 252));
        g2d.fillRoundRect(x, y, w, h, 26, 26);
        g2d.setColor(new Color(244, 114, 182, 180));
        g2d.setStroke(new BasicStroke(2.0f));
        g2d.drawRoundRect(x, y, w, h, 26, 26);

        // Header pill gradient
        int pillW = w - 32;
        int pillH = 42;
        int pillX = x + 16;
        int pillY = y + 20;

        g2d.setColor(new Color(225, 29, 72, 40));
        g2d.fillRoundRect(pillX + 2, pillY + 3, pillW, pillH, 20, 20);

        GradientPaint gp = new GradientPaint(pillX, pillY, new Color(244, 63, 94), pillX + pillW, pillY, new Color(225, 29, 72));
        g2d.setPaint(gp);
        g2d.fillRoundRect(pillX, pillY, pillW, pillH, 20, 20);

        g2d.setFont(new Font("Segoe UI", Font.BOLD, 14));
        g2d.setColor(Color.WHITE);
        FontMetrics fm = g2d.getFontMetrics();
        String tag = "✨ TRENDY DRINKS & COFFEE ✨";
        g2d.drawString(tag, pillX + (pillW - fm.stringWidth(tag)) / 2, pillY + 26);

        // Tên Quán / Thương Hiệu
        g2d.setFont(new Font("Segoe UI", Font.BOLD, 22));
        g2d.setColor(new Color(15, 23, 42));
        g2d.drawString(brandName, pillX, pillY + 80);

        // Slogan quán
        g2d.setFont(new Font("Segoe UI", Font.BOLD, 12));
        g2d.setColor(new Color(190, 24, 93));
        g2d.drawString(slogan, pillX, pillY + 110);

        // Lời giới thiệu ngắn
        g2d.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        g2d.setColor(new Color(100, 116, 139));
        g2d.drawString(desc, pillX, pillY + 138);
        g2d.drawString("Phục vụ từ 07:00 - 22:30 mỗi ngày", pillX, pillY + 160);

        // Dải cam kết chất lượng
        g2d.setColor(new Color(254, 243, 199));
        g2d.fillRoundRect(pillX, pillY + 195, pillW, 40, 12, 12);
        g2d.setColor(new Color(217, 119, 6));
        g2d.setFont(new Font("Segoe UI", Font.BOLD, 12));
        g2d.drawString("★ 100% NGUYÊN LIỆU TƯƠI SẠCH ★", pillX + 18, pillY + 220);

        // Mini highlight badge
        g2d.setColor(new Color(241, 245, 249));
        g2d.fillRoundRect(pillX, pillY + 250, pillW, 60, 14, 14);
        g2d.setColor(new Color(15, 23, 42));
        g2d.setFont(new Font("Segoe UI", Font.BOLD, 12));
        g2d.drawString("ƯU ĐÃI ĐỒNG GIÁ TOPPING", pillX + 12, pillY + 273);
        g2d.setFont(new Font("Segoe UI", Font.PLAIN, 11));
        g2d.setColor(new Color(100, 116, 139));
        g2d.drawString("Chỉ từ 5.000đ - 7.000đ khi gọi kèm món", pillX + 12, pillY + 295);
    }

    private static void renderCategoryCard(
            Graphics2D g2d,
            String headerTitle,
            int x, int startY, int width,
            String[][] items,
            Color themeColor,
            Color badgeBg) {

        // Badge tiêu đề danh mục bo tròn thanh lịch
        int badgeH = 34;
        g2d.setColor(badgeBg);
        g2d.fillRoundRect(x, startY, width, badgeH, 12, 12);
        g2d.setColor(new Color(themeColor.getRed(), themeColor.getGreen(), themeColor.getBlue(), 80));
        g2d.setStroke(new BasicStroke(1.2f));
        g2d.drawRoundRect(x, startY, width, badgeH, 12, 12);

        // Icon hoa nhỏ + Tiêu đề
        g2d.setFont(new Font("Segoe UI", Font.BOLD, 14));
        g2d.setColor(themeColor);
        g2d.drawString(headerTitle, x + 10, startY + 23);

        // Chữ GIÁ TIỀN bên phải
        g2d.setFont(new Font("Segoe UI", Font.BOLD, 10));
        g2d.setColor(new Color(148, 163, 184));
        g2d.drawString("GIÁ (VNĐ)", x + width - 62, startY + 22);

        int curY = startY + 52;
        Font fontItem = new Font("Segoe UI", Font.BOLD, 12);
        Font fontPrice = new Font("Segoe UI", Font.BOLD, 12);

        for (String[] it : items) {
            String name = it[0];
            String price = it[1];
            String badge = it[2];

            // Badge dot
            if ("HERO".equals(badge)) {
                g2d.setColor(new Color(225, 29, 72));
                g2d.fillOval(x + 2, curY - 9, 6, 6);
            } else if ("GIFT".equals(badge)) {
                g2d.setColor(new Color(217, 119, 6));
                g2d.fillOval(x + 2, curY - 9, 6, 6);
            } else {
                g2d.setColor(new Color(203, 213, 225));
                g2d.fillOval(x + 2, curY - 8, 4, 4);
            }

            // Tên món
            g2d.setFont(fontItem);
            g2d.setColor(new Color(30, 41, 59));
            g2d.drawString(name, x + 14, curY);

            // Dòng chấm nối tên và giá
            FontMetrics fmItem = g2d.getFontMetrics(fontItem);
            FontMetrics fmPrice = g2d.getFontMetrics(fontPrice);
            int nameW = fmItem.stringWidth(name);
            int priceW = fmPrice.stringWidth(price);

            int dotStart = x + 18 + nameW;
            int dotEnd = x + width - priceW - 8;
            if (dotEnd > dotStart) {
                g2d.setColor(new Color(203, 213, 225));
                for (int dx = dotStart; dx < dotEnd; dx += 6) {
                    g2d.fillRect(dx, curY - 3, 2, 2);
                }
            }

            // Giá tiền
            g2d.setFont(fontPrice);
            g2d.setColor(themeColor);
            g2d.drawString(price, x + width - priceW, curY);

            curY += 26;
        }
    }
}
