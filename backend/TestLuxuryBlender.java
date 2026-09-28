import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.util.Random;

public class TestLuxuryBlender {
    public static void main(String[] args) throws Exception {
        File srcFile = new File("d:/Smart_Menu/backend/src/main/resources/menu-style/SANG_TRONG/reference.png");
        BufferedImage img = ImageIO.read(srcFile);

        Graphics2D g2d = img.createGraphics();
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2d.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);

        int patchX = 530;
        int patchY = 25;
        int patchW = 550;
        int patchH = 325;

        // Create feathered gradient patch with fine sand noise
        BufferedImage patch = new BufferedImage(patchW, patchH, BufferedImage.TYPE_INT_ARGB);
        Random rand = new Random(42);

        int feather = 25;

        for (int y = 0; y < patchH; y++) {
            float vFactor = (float) y / patchH;
            for (int x = 0; x < patchW; x++) {
                float hFactor = (float) x / patchW;

                // Color interpolation matching the sand wall
                // Left-top: (192, 140, 92) -> Right-top: (230, 222, 204)
                // Left-bot: (195, 145, 90) -> Right-bot: (234, 195, 145)
                int rTop = (int) (192 + (230 - 192) * hFactor);
                int gTop = (int) (140 + (222 - 140) * hFactor);
                int bTop = (int) (92 + (204 - 92) * hFactor);

                int rBot = (int) (195 + (234 - 195) * hFactor);
                int gBot = (int) (145 + (195 - 145) * hFactor);
                int bBot = (int) (90 + (145 - 90) * hFactor);

                int r = (int) (rTop + (rBot - rTop) * vFactor);
                int g = (int) (gTop + (gBot - gTop) * vFactor);
                int b = (int) (bTop + (bBot - bTop) * vFactor);

                // Add fine sand plaster noise
                int noise = rand.nextInt(7) - 3;
                r = Math.min(255, Math.max(0, r + noise));
                g = Math.min(255, Math.max(0, g + noise));
                b = Math.min(255, Math.max(0, b + noise));

                // Calculate edge alpha feather
                int distLeft = x;
                int distRight = patchW - 1 - x;
                int distTop = y;
                int distBot = patchH - 1 - y;
                int minDist = Math.min(Math.min(distLeft, distRight), Math.min(distTop, distBot));

                int alpha = 255;
                if (minDist < feather) {
                    alpha = (int) (255 * (minDist / (float) feather));
                }

                int argb = (alpha << 24) | (r << 16) | (g << 8) | b;
                patch.setRGB(x, y, argb);
            }
        }

        // Draw blended patch
        g2d.drawImage(patch, patchX, patchY, null);

        // Draw Vietnamese Menu Text
        Font fontHeader = new Font("Serif", Font.BOLD, 13);
        Font fontItem = new Font("Serif", Font.BOLD, 11);
        Color colHeader = new Color(252, 248, 240); // Soft white
        Color colItem = new Color(28, 20, 15); // Deep espresso

        // Column 1
        int col1X = 555;
        int col1W = 230;
        g2d.setFont(fontHeader);
        g2d.setColor(colHeader);
        g2d.drawString("CÀ PHÊ TRUYỀN THỐNG", col1X, 55);

        g2d.setFont(fontItem);
        g2d.setColor(colItem);
        int yPos = 80;
        String[][] col1Items = {
            {"Cà phê sữa đá", "37,000"},
            {"Cà phê đen đá", "30,000"},
            {"Americano", "42,000"},
            {"Bạc xỉu", "41,000"}
        };
        for (String[] it : col1Items) {
            g2d.drawString(it[0], col1X, yPos);
            FontMetrics fm = g2d.getFontMetrics();
            g2d.drawString(it[1], col1X + col1W - fm.stringWidth(it[1]), yPos);
            yPos += 20;
        }

        // Category 2 in Column 1
        g2d.setFont(fontHeader);
        g2d.setColor(colHeader);
        g2d.drawString("TRÀ TRÁI CÂY", col1X, 225);

        g2d.setFont(fontItem);
        g2d.setColor(colItem);
        yPos = 250;
        String[][] col1Cat2 = {
            {"Trà đào cam sả", "47,000"},
            {"Trà chanh mật ong", "38,000"},
            {"Trà vải hoa hồng", "47,000"}
        };
        for (String[] it : col1Cat2) {
            g2d.drawString(it[0], col1X, yPos);
            FontMetrics fm = g2d.getFontMetrics();
            g2d.drawString(it[1], col1X + col1W - fm.stringWidth(it[1]), yPos);
            yPos += 20;
        }

        // Column 2
        int col2X = 825;
        int col2W = 230;
        g2d.setFont(fontHeader);
        g2d.setColor(colHeader);
        g2d.drawString("ĐÁ XAY & MATCHA", col2X, 55);

        g2d.setFont(fontItem);
        g2d.setColor(colItem);
        yPos = 80;
        String[][] col2Items = {
            {"Matcha đá xay", "61,000"},
            {"Chocolate đá xay", "60,000"},
            {"Cookies & cream đá xay", "62,000"}
        };
        for (String[] it : col2Items) {
            g2d.drawString(it[0], col2X, yPos);
            FontMetrics fm = g2d.getFontMetrics();
            g2d.drawString(it[1], col2X + col2W - fm.stringWidth(it[1]), yPos);
            yPos += 20;
        }

        // Category 4 in Column 2
        g2d.setFont(fontHeader);
        g2d.setColor(colHeader);
        g2d.drawString("SIGNATURE DRINKS", col2X, 225);

        g2d.setFont(fontItem);
        g2d.setColor(colItem);
        yPos = 250;
        String[][] col2Cat2 = {
            {"Cold brew cam vàng", "62,000"}
        };
        for (String[] it : col2Cat2) {
            // Hero badge
            g2d.setColor(new Color(220, 38, 38));
            g2d.fillOval(col2X - 10, yPos - 7, 5, 5);
            g2d.setColor(colItem);
            g2d.drawString(it[0], col2X, yPos);
            FontMetrics fm = g2d.getFontMetrics();
            g2d.drawString(it[1], col2X + col2W - fm.stringWidth(it[1]), yPos);
            yPos += 20;
        }

        g2d.dispose();
        File outFile = new File("d:/Smart_Menu/backend/test_luxury_seamless.png");
        boolean ok = ImageIO.write(img, "png", outFile);
        System.out.println("RESULT_WRITE=" + ok + " PATH=" + outFile.getAbsolutePath() + " LENGTH=" + outFile.length());
    }
}
