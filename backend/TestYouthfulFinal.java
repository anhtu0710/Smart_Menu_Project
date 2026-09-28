import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;

public class TestYouthfulFinal {
    public static void main(String[] args) throws Exception {
        // Đọc template_clean.png đã xóa 100% text cũ
        File srcFile = new File("d:/Smart_Menu/backend/src/main/resources/menu-style/TRE_TRUNG/template_clean.png");
        BufferedImage canvas = ImageIO.read(srcFile);

        Graphics2D g2d = canvas.createGraphics();
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2d.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
        g2d.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        g2d.setRenderingHint(RenderingHints.KEY_FRACTIONALMETRICS, RenderingHints.VALUE_FRACTIONALMETRICS_ON);

        // 1. BRAND CARD GÓC TRÊN TRÁI
        renderBrandHeaderCard(g2d, 16, 16, 326, 450,
                "SWEET CORNER CAFE",
                "♡ Tươi mát mỗi ngày • Thơm ngon từng khoảnh khắc ♡",
                "Thực đơn chọn lọc từ hạt cà phê và trà hảo hạng");

        // 2. RENDER 5 DANH MỤC MAP THEO DỮ LIỆU THỰC TẾ
        // Card 1: Cà phê (Cột 1 Trên: X: 350, Y: 30, W: 270)
        renderCategoryCard(g2d, "✿ CÀ PHÊ PHIN & ESPRESSO", 350, 30, 270, new String[][]{
                {"Cà phê đen đá", "25.000đ", "HERO"},
                {"Cà phê sữa đá Sài Gòn", "29.000đ", "HERO"},
                {"Bạc xỉu 3 tầng kem sữa", "32.000đ", ""},
                {"Cà phê muối béo ngậy", "35.000đ", "GIFT"},
                {"Latte cốt dừa nướng", "39.000đ", ""},
                {"Americano bưởi hồng", "35.000đ", ""},
                {"Caramel Macchiato", "42.000đ", ""}
        }, new Color(225, 29, 72), new Color(255, 241, 242));

        // Card 2: Trà sữa (Cột 2 Trên: X: 665, Y: 30, W: 295)
        renderCategoryCard(g2d, "✿ TRÀ SỮA ĐẬM VỊ", 665, 30, 295, new String[][]{
                {"Trà sữa truyền thống nướng", "30.000đ", "HERO"},
                {"Trà sữa Thái xanh thạch dừa", "32.000đ", ""},
                {"Trà sữa socola hạt phỉ", "35.000đ", ""},
                {"Trà sữa ô long nướng", "35.000đ", "GIFT"},
                {"Trà sữa trân châu đường đen", "38.000đ", "HERO"},
                {"Trà sữa kem cheese béo", "39.000đ", ""},
                {"Trà sữa khoai môn dẻo", "35.000đ", ""}
        }, new Color(47, 133, 90), new Color(240, 253, 244));

        // Card 3: Trà trái cây (Cột 1 Dưới: X: 350, Y: 495, W: 270)
        renderCategoryCard(g2d, "✿ TRÀ TRÁI CÂY TƯƠI", 350, 495, 270, new String[][]{
                {"Trà đào cam sả hạt chia", "35.000đ", "HERO"},
                {"Trà dâu tằm tuyết nhĩ", "38.000đ", "GIFT"},
                {"Trà xoài nhiệt đới chanh dây", "39.000đ", ""},
                {"Trà chanh hoa đậu biếc", "30.000đ", ""},
                {"Trà vải thiều thanh mát", "35.000đ", ""},
                {"Trà tắc xí muội giải nhiệt", "32.000đ", ""}
        }, new Color(234, 88, 12), new Color(255, 247, 237));

        // Card 4: Đá xay (Cột 2 Giữa: X: 665, Y: 495, W: 295)
        renderCategoryCard(g2d, "✿ ĐÁ XAY & MATCHA", 665, 495, 295, new String[][]{
                {"Matcha đá xay kem tuyết", "45.000đ", "HERO"},
                {"Cookies đá xay socola", "45.000đ", "HERO"},
                {"Caramel đá xay hạnh nhân", "48.000đ", ""},
                {"Dâu tây đá xay sữa chua", "45.000đ", "GIFT"},
                {"Matcha latte Nhật Bản", "42.000đ", ""}
        }, new Color(37, 99, 235), new Color(239, 246, 255));

        // Card 5: Signature (Cột 2 Dưới: X: 665, Y: 745, W: 295)
        renderCategoryCard(g2d, "✿ SIGNATURE ĐẶC BIỆT", 665, 745, 295, new String[][]{
                {"Cold Brew cam vàng mật ong", "45.000đ", "HERO"},
                {"Nước ép cam nha đam tươi", "35.000đ", ""},
                {"Nước ép ổi hồng trân châu", "35.000đ", "GIFT"},
                {"Sữa chua dẻo hạt lựu đỏ", "38.000đ", ""}
        }, new Color(168, 85, 247), new Color(250, 245, 255));

        g2d.dispose();

        File outFile = new File("d:/Smart_Menu/backend/test_youthful_final_result.png");
        ImageIO.write(canvas, "png", outFile);
        System.out.println("Rendered: " + outFile.getAbsolutePath());
    }

    private static void renderBrandHeaderCard(Graphics2D g2d, int x, int y, int w, int h, String brandName, String slogan, String desc) {
        g2d.setColor(new Color(255, 252, 248, 252));
        g2d.fillRoundRect(x, y, w, h, 26, 26);
        g2d.setColor(new Color(244, 114, 182, 180));
        g2d.setStroke(new BasicStroke(2.0f));
        g2d.drawRoundRect(x, y, w, h, 26, 26);

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

        g2d.setFont(new Font("Segoe UI", Font.BOLD, 22));
        g2d.setColor(new Color(15, 23, 42));
        g2d.drawString(brandName, pillX, pillY + 80);

        g2d.setFont(new Font("Segoe UI", Font.BOLD, 12));
        g2d.setColor(new Color(190, 24, 93));
        g2d.drawString(slogan, pillX, pillY + 110);

        g2d.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        g2d.setColor(new Color(100, 116, 139));
        g2d.drawString(desc, pillX, pillY + 138);
        g2d.drawString("Phục vụ từ 07:00 - 22:30 mỗi ngày", pillX, pillY + 160);

        g2d.setColor(new Color(254, 243, 199));
        g2d.fillRoundRect(pillX, pillY + 195, pillW, 40, 12, 12);
        g2d.setColor(new Color(217, 119, 6));
        g2d.setFont(new Font("Segoe UI", Font.BOLD, 12));
        g2d.drawString("★ 100% NGUYÊN LIỆU TƯƠI SẠCH ★", pillX + 18, pillY + 220);

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

        int badgeH = 34;
        g2d.setColor(badgeBg);
        g2d.fillRoundRect(x, startY, width, badgeH, 12, 12);
        g2d.setColor(new Color(themeColor.getRed(), themeColor.getGreen(), themeColor.getBlue(), 80));
        g2d.setStroke(new BasicStroke(1.2f));
        g2d.drawRoundRect(x, startY, width, badgeH, 12, 12);

        g2d.setFont(new Font("Segoe UI", Font.BOLD, 14));
        g2d.setColor(themeColor);
        g2d.drawString(headerTitle, x + 10, startY + 23);

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

            g2d.setFont(fontItem);
            g2d.setColor(new Color(30, 41, 59));
            g2d.drawString(name, x + 14, curY);

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

            g2d.setFont(fontPrice);
            g2d.setColor(themeColor);
            g2d.drawString(price, x + width - priceW, curY);

            curY += 26;
        }
    }
}
