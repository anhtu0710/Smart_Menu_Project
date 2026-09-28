import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.util.Random;

public class TestVintageBrewBlender {
    public static void main(String[] args) throws Exception {
        File srcFile = new File("d:/Smart_Menu/backend/src/main/resources/menu-style/TRUYEN_THONG/reference.png");
        BufferedImage img = ImageIO.read(srcFile);

        Graphics2D g2d = img.createGraphics();
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2d.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
        g2d.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);

        // 4 inpaint patches for the 4 item list zones
        inpaintParchment(g2d, 35, 305, 300, 185); // Cat 1
        inpaintParchment(g2d, 360, 305, 295, 185); // Cat 2
        inpaintParchment(g2d, 35, 575, 300, 105); // Cat 3
        inpaintParchment(g2d, 360, 575, 295, 105); // Cat 4

        // Font and Colors matching the Vietnamese vintage menu
        Font fontItem = new Font("Serif", Font.BOLD, 12);
        Color colItem = new Color(35, 24, 18); // Deep warm sepia-black

        // Cat 1: CÀ PHÊ (X: 42..325)
        int col1X = 42;
        int col1Right = 322;
        int yPos = 328;
        String[][] cat1 = {
            {"Cà phê sữa đá", "37.000"},
            {"Cà phê đen đá", "30.000"},
            {"Bạc xỉu", "41.000"},
            {"Americano", "42.000"}
        };
        g2d.setFont(fontItem);
        g2d.setColor(colItem);
        FontMetrics fm = g2d.getFontMetrics();
        for (String[] it : cat1) {
            g2d.drawString(it[0], col1X, yPos);
            g2d.drawString(it[1], col1Right - fm.stringWidth(it[1]), yPos);
            yPos += 26;
        }

        // Cat 2: TRÀ TRÁI CÂY (X: 368..648)
        int col2X = 368;
        int col2Right = 645;
        yPos = 328;
        String[][] cat2 = {
            {"Trà đào cam sả", "47.000"},
            {"Trà vải hoa hồng", "47.000"},
            {"Trà chanh mật ong", "38.000"}
        };
        for (String[] it : cat2) {
            g2d.drawString(it[0], col2X, yPos);
            g2d.drawString(it[1], col2Right - fm.stringWidth(it[1]), yPos);
            yPos += 26;
        }

        // Cat 3: ĐÁ XAY & MATCHA
        yPos = 598;
        String[][] cat3 = {
            {"Matcha đá xay", "61.000"},
            {"Cookies & cream đá xay", "62.000"},
            {"Chocolate đá xay", "60.000"}
        };
        for (String[] it : cat3) {
            g2d.drawString(it[0], col1X, yPos);
            g2d.drawString(it[1], col1Right - fm.stringWidth(it[1]), yPos);
            yPos += 26;
        }

        // Cat 4: SIGNATURE
        yPos = 598;
        String[][] cat4 = {
            {"Cold brew cam vàng", "62.000"}
        };
        for (String[] it : cat4) {
            // Hero star icon
            g2d.setColor(new Color(180, 83, 9));
            g2d.drawString("★", col2X, yPos);
            g2d.setColor(colItem);
            g2d.drawString("  " + it[0], col2X + 10, yPos);
            g2d.drawString(it[1], col2Right - fm.stringWidth(it[1]), yPos);
            yPos += 26;
        }

        g2d.dispose();
        File outFile = new File("d:/Smart_Menu/backend/test_vintage_brew.png");
        ImageIO.write(img, "png", outFile);
        System.out.println("SUCCESS: Generated " + outFile.getAbsolutePath());
    }

    private static void inpaintParchment(Graphics2D g2d, int x, int y, int w, int h) {
        BufferedImage patch = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);
        Random rand = new Random(42);
        int feather = 10;

        for (int py = 0; py < h; py++) {
            for (int px = 0; px < w; px++) {
                int r = 233 + rand.nextInt(5) - 2;
                int g = 221 + rand.nextInt(5) - 2;
                int b = 204 + rand.nextInt(5) - 2;

                int distLeft = px;
                int distRight = w - 1 - px;
                int distTop = py;
                int distBot = h - 1 - py;
                int minDist = Math.min(Math.min(distLeft, distRight), Math.min(distTop, distBot));

                int alpha = 255;
                if (minDist < feather) {
                    alpha = (int) (255 * (minDist / (float) feather));
                }

                int argb = (alpha << 24) | (r << 16) | (g << 8) | b;
                patch.setRGB(px, py, argb);
            }
        }
        g2d.drawImage(patch, x, y, null);
    }
}
