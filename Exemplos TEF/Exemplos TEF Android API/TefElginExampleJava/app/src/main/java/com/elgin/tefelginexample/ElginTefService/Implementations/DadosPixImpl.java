package com.elgin.tefelginexample.ElginTefService.Implementations;

import android.app.AlertDialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;
import android.widget.ImageView;

import java.util.Optional;
import java.util.function.Function;

public class DadosPixImpl implements Function<String, Optional<AlertDialog.Builder>> {
    private final Context mContext;

    public DadosPixImpl (Context mContext) {
        this.mContext = mContext;
    }

    @Override
    public Optional<AlertDialog.Builder> apply(String qrCodeHexa) {
        Log.d("MADARA PIX", "happened!");

        final AlertDialog.Builder builder = new AlertDialog.Builder(mContext);

        builder.setMessage("Abra o app do seu banco e realize o pagamento");
        // builder.setMessage(qrCodeHexa);


        ImageView qrCodeImage = new ImageView(mContext);
        byte[] imageBytes = hexToByteArray(qrCodeHexa);
        Bitmap decodedImage = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.length);
        qrCodeImage.setImageBitmap(decodedImage);

        builder.setView(qrCodeImage);

        return Optional.of(builder);

    }


    public static byte[] hexToByteArray(String hex) {
        hex = hex.length() % 2 != 0 ? "0" + hex : hex;
        byte[] b = new byte[hex.length() / 2];

        for(int i = 0; i < b.length; ++i) {
            int index = i * 2;
            int v = Integer.parseInt(hex.substring(index, index + 2), 16);
            b[i] = (byte)v;
        }

        return b;
    }
}
