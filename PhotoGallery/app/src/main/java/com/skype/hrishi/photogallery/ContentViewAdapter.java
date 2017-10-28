package com.skype.hrishi.photogallery;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Build;
import android.provider.MediaStore;
import android.support.v7.widget.CardView;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.squareup.picasso.Picasso;

import org.greenrobot.eventbus.EventBus;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by hrishi on 10/15/17.
 */

public class ContentViewAdapter extends RecyclerView.Adapter<ContentViewAdapter.ItemHolder> {

    private List<Uri> itemsUri;
    private List<Long> itemsVideo;
    private List<Uri> selectedPhotosUri;
    private List<Long> selectedItemsVideo;
    private Context mContext;
    private LayoutInflater layoutInflater;
    private int assetType;


    public ContentViewAdapter(Context context, int type) {
        mContext = context;
        layoutInflater = LayoutInflater.from(context);
        itemsUri = new ArrayList<>();
        itemsVideo = new ArrayList<>();
        selectedPhotosUri = new ArrayList<>();
        selectedItemsVideo = new ArrayList<>();
        assetType = type;
    }

    @Override
    public ContentViewAdapter.ItemHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        CardView itemCardView = (CardView) layoutInflater.inflate(R.layout.layout_cardview, parent, false);
        return new ItemHolder(itemCardView);
    }

    @Override
    public void onBindViewHolder(final ContentViewAdapter.ItemHolder holder, int position) {
       if (assetType == AssetType.IMAGE) {
           final Uri targetUri = itemsUri.get(position);

           if (targetUri != null) {
               Picasso.with(mContext)
                       .load(targetUri)
                       .fit()
                       .centerCrop()
                       .into(holder.imageView);
           }
           holder.imageView.setOnClickListener(new View.OnClickListener() {
               @Override
               public void onClick(View v) {
                   if (holder.checkBoxView.getVisibility() == View.INVISIBLE) {
                       holder.checkBoxView.setVisibility(View.VISIBLE);
                       selectedPhotosUri.add(targetUri);
                   } else {
                       holder.checkBoxView.setVisibility(View.INVISIBLE);
                       selectedPhotosUri.remove(targetUri);
                   }
                   EventBus.getDefault().post(new SelectionEvent(selectedPhotosUri.size(), AssetType.IMAGE, selectedPhotosUri, null));
               }
           });

       } else {
           final Long targetID = itemsVideo.get(position);
           if (targetID != null) {
               Bitmap bitmap = MediaStore.Video.Thumbnails.getThumbnail(
                       mContext.getContentResolver(),
                       targetID,
                       MediaStore.Video.Thumbnails.MINI_KIND, null);
               holder.setImageView(bitmap);
           }
           holder.imageView.setOnClickListener(new View.OnClickListener() {
               @Override
               public void onClick(View v) {
                   if (holder.checkBoxView.getVisibility() == View.INVISIBLE) {
                       holder.checkBoxView.setVisibility(View.VISIBLE);
                       selectedItemsVideo.add(targetID);
                   } else {
                       holder.checkBoxView.setVisibility(View.INVISIBLE);
                       selectedItemsVideo.remove(targetID);
                   }
                   EventBus.getDefault().post(new SelectionEvent(selectedItemsVideo.size(), AssetType.VIDEO, null, selectedItemsVideo));
               }
           });
       }
    }

    @Override
    public int getItemCount() {
        if (assetType == AssetType.IMAGE) {
            return itemsUri.size();
        } else {
            return itemsVideo.size();
        }
    }

    public static class ItemHolder extends RecyclerView.ViewHolder {

        ImageView imageView;
        ImageView checkBoxView;

        public ItemHolder(CardView cardView) {
            super(cardView);
            this.imageView = cardView.findViewById(R.id.item_image);
            this.checkBoxView = cardView.findViewById(R.id.item_selected);
        }

        public void setImageView(Bitmap bitmap) {
            imageView.setImageBitmap(bitmap);
        }

    }

    public void add(int location, Uri iUri) {
        itemsUri.add(location, iUri);
        notifyItemInserted(location);
    }

    public void addVideo(int location, Long videoID) {
        itemsVideo.add(itemsVideo.size(), videoID);
        notifyItemInserted(location);
    }

    public void setSelectedPhotos(List<Uri> iUris) {
        itemsUri = iUris;
        notifyDataSetChanged();
    }

    public void setSelectedVideos(List<Long> videoIDs) {
        itemsVideo = videoIDs;
        notifyDataSetChanged();
    }

    public void clearAll() {
        int itemCount = itemsUri.size();

        if (itemCount > 0) {
            itemsUri.clear();
            notifyItemRangeRemoved(0, itemCount);
        }
    }

    private Bitmap loadScaledBitmap(Uri src) throws IOException {

        final int REQ_WIDTH = 200;
        final int REQ_HEIGHT = 200;

        Bitmap bm = null;

        final BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        BitmapFactory.decodeStream(mContext.getContentResolver().openInputStream(src),
                null, options);

        options.inSampleSize = calculateInSampleSize(options, REQ_WIDTH,
                REQ_HEIGHT);

        options.inJustDecodeBounds = false;
        bm = BitmapFactory.decodeStream(
                mContext.getContentResolver().openInputStream(src), null, options);

        bm = rotateImageIfRequired(mContext, bm, src);
        return bm;
    }

    public int calculateInSampleSize(BitmapFactory.Options options,
                                     int reqWidth, int reqHeight) {
        // Raw height and width of image
        final int height = options.outHeight;
        final int width = options.outWidth;
        int inSampleSize = 1;

        if (height > reqHeight || width > reqWidth) {

            // Calculate ratios of height and width to requested height and
            // width
            final int heightRatio = Math.round((float) height
                    / (float) reqHeight);
            final int widthRatio = Math.round((float) width / (float) reqWidth);

            inSampleSize = heightRatio < widthRatio ? heightRatio : widthRatio;

        }

        return inSampleSize;
    }

    private static Bitmap rotateImageIfRequired(Context context, Bitmap img, Uri selectedImage) throws IOException {

        InputStream input = context.getContentResolver().openInputStream(selectedImage);
        ExifInterface ei;
        if (Build.VERSION.SDK_INT > 23)
            ei = new ExifInterface(input);
        else
            ei = new ExifInterface(selectedImage.getPath());

        int orientation = ei.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL);

        switch (orientation) {
            case ExifInterface.ORIENTATION_ROTATE_90:
                return rotateImage(img, 90);
            case ExifInterface.ORIENTATION_ROTATE_180:
                return rotateImage(img, 180);
            case ExifInterface.ORIENTATION_ROTATE_270:
                return rotateImage(img, 270);
            default:
                return img;
        }
    }

    private static Bitmap rotateImage(Bitmap img, int degree) {
        Matrix matrix = new Matrix();
        matrix.postRotate(degree);
        Bitmap rotatedImg = Bitmap.createBitmap(img, 0, 0, img.getWidth(), img.getHeight(), matrix, true);
        img.recycle();
        return rotatedImg;
    }

}
