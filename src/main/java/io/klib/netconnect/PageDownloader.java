package io.klib.netconnect;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;

public class PageDownloader {
    public static void main(String[] args) {

        URL url;
        InputStream is = null;
        BufferedReader br;
        String line;
        String input = args[0];

        try {
            url = new URL(input);
            is = url.openStream();  // throws an IOException
            br = new BufferedReader(new InputStreamReader(is));

            while ((line = br.readLine()) != null) {
                System.out.println(line);
            }
        } catch (MalformedURLException mue) {
            mue.printStackTrace();
            System.exit(1);
        } catch (IOException ioe) {
            ioe.printStackTrace();
            System.exit(1);
        } finally {
            try {
                if (is != null) is.close();
                System.exit(0);
            } catch (IOException ioe) {
                System.exit(1);
            }
        }

    }
}
