package com.skype.hrishi.photogallery;

import android.Manifest;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;

import java.util.List;

public class MainActivity extends AppCompatActivity {

    private TextView mPhotosSelectedTextView;
    private RecyclerView mRecyclerImageView;
    private TextView mVideosSelectedTextView;
    private RecyclerView mRecyclerVideoView;
    private RecyclerView mRecyclerSelectedPhotos;
    private RecyclerView mRecyclerSelectedVideos;
    private ContentViewAdapter mPhotoContentViewAdapter;
    private ContentViewAdapter mVideoContentViewAdapter;
    private ContentViewAdapter mSelectedPhotoViewAdapter;
    private ContentViewAdapter mSelectedVideoContentViewAdapter;
    private LinearLayoutManager mLinearLayoutManager;
    private Button mSelectButton;
    private List<Uri> mSelectedPhotosUri;
    private List<Long> mSelectedItemsVideo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //Photos selected
        mPhotosSelectedTextView = (TextView) findViewById(R.id.photosSelected);
        //Photo Recycler View
        mPhotoContentViewAdapter = new ContentViewAdapter(this, AssetType.IMAGE);
        mRecyclerImageView = (RecyclerView) findViewById(R.id.imagegallery);
        mRecyclerImageView.setAdapter(mPhotoContentViewAdapter);
        mRecyclerImageView.setHasFixedSize(true);
        mRecyclerImageView.setDrawingCacheEnabled(true);
        mRecyclerImageView.setDrawingCacheQuality(View.DRAWING_CACHE_QUALITY_HIGH);
        mLinearLayoutManager =
                new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false);
        mRecyclerImageView.setLayoutManager(mLinearLayoutManager);

        //Video selected
        mVideosSelectedTextView = (TextView) findViewById(R.id.videosSelected);
        //Video Recycler View
        mVideoContentViewAdapter = new ContentViewAdapter(this, AssetType.VIDEO);
        mRecyclerVideoView = (RecyclerView) findViewById(R.id.videogallery);
        mRecyclerVideoView.setAdapter(mVideoContentViewAdapter);
        mRecyclerVideoView.setHasFixedSize(true);
        mRecyclerVideoView.setDrawingCacheEnabled(true);
        mRecyclerVideoView.setDrawingCacheQuality(View.DRAWING_CACHE_QUALITY_HIGH);
        mLinearLayoutManager =
                new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false);
        mRecyclerVideoView.setLayoutManager(mLinearLayoutManager);

        mSelectedPhotoViewAdapter = new ContentViewAdapter(this, AssetType.IMAGE);
        mRecyclerSelectedPhotos = (RecyclerView) findViewById(R.id.imagegalleryselected);
        mRecyclerSelectedPhotos.setAdapter(mSelectedPhotoViewAdapter);
        mRecyclerSelectedPhotos.setHasFixedSize(true);
        mRecyclerSelectedPhotos.setDrawingCacheEnabled(true);
        mRecyclerSelectedPhotos.setDrawingCacheQuality(View.DRAWING_CACHE_QUALITY_HIGH);
        mLinearLayoutManager =
                new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false);
        mRecyclerSelectedPhotos.setLayoutManager(mLinearLayoutManager);

        mSelectedVideoContentViewAdapter = new ContentViewAdapter(this, AssetType.VIDEO);
        mRecyclerSelectedVideos = (RecyclerView) findViewById(R.id.videogalleryselected);
        mRecyclerSelectedVideos.setAdapter(mSelectedVideoContentViewAdapter);
        mRecyclerSelectedVideos.setHasFixedSize(true);
        mRecyclerSelectedVideos.setDrawingCacheEnabled(true);
        mRecyclerSelectedVideos.setDrawingCacheQuality(View.DRAWING_CACHE_QUALITY_HIGH);
        mLinearLayoutManager =
                new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false);
        mRecyclerSelectedVideos.setLayoutManager(mLinearLayoutManager);

        mSelectButton = (Button) findViewById(R.id.fabButton);
        mSelectButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mSelectedPhotosUri != null) {
                    mRecyclerSelectedPhotos.setVisibility(View.VISIBLE);
                    mSelectedPhotoViewAdapter.setSelectedPhotos(mSelectedPhotosUri);
                }
                if (mSelectedItemsVideo != null) {
                    mRecyclerSelectedVideos.setVisibility(View.VISIBLE);
                    mSelectedVideoContentViewAdapter.setSelectedVideos(mSelectedItemsVideo);
                }
            }
        });
        // Here, thisActivity is the current activity
        if (ContextCompat.checkSelfPermission(this,
                Manifest.permission.READ_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this,
                    new String[]{Manifest.permission.READ_EXTERNAL_STORAGE},
                    1);
        } else {
            getAllShownImagesPath();
            getAllShownVideosPath();
        }
        EventBus.getDefault().register(this);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        EventBus.getDefault().unregister(this);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           String permissions[], int[] grantResults) {
        switch (requestCode) {
            case 1: {
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    getAllShownImagesPath();
                    getAllShownVideosPath();
                }
                return;
            }
        }
    }

    public void getAllShownImagesPath() {
        String[] projection = {MediaStore.Images.Media._ID};
        Cursor cursor = this.getApplicationContext().getContentResolver().query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                projection, // Which columns to return
                null,       // Return all rows
                null,
                null);

        if (cursor.moveToFirst()) {
            do {
                int imageID = cursor.getInt(cursor.getColumnIndexOrThrow(MediaStore.Images.Media._ID));
                Uri uri = Uri.withAppendedPath(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                        Integer.toString(imageID));
                mPhotoContentViewAdapter.add(mPhotoContentViewAdapter.getItemCount(), uri);
            } while (cursor.moveToNext());
        }
        String text = String.format(getResources().getString(R.string.assets_selected), 0, mPhotoContentViewAdapter.getItemCount());
        mPhotosSelectedTextView.setText(text);
    }

    public void getAllShownVideosPath() {
        String[] projection = {MediaStore.Video.Media._ID,
                MediaStore.Video.Media.DATA,
                MediaStore.Video.Thumbnails.DATA};
        Cursor cursor = this.getApplicationContext().getContentResolver().query(MediaStore.Video.Media.EXTERNAL_CONTENT_URI,
                projection, null, null, null);

        if (cursor.moveToFirst()) {
            do {
                long videoID = cursor.getInt(cursor.getColumnIndexOrThrow(MediaStore.Video.Media._ID));
                mVideoContentViewAdapter.addVideo(mVideoContentViewAdapter.getItemCount(), videoID);
            } while (cursor.moveToNext());
        }
        String text = String.format(getResources().getString(R.string.assets_selected), 0, mVideoContentViewAdapter.getItemCount());
        mVideosSelectedTextView.setText(text);
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onSelectionEvent(SelectionEvent event) {
        if (event.getAssetType() == AssetType.IMAGE) {
            String text = String.format(getResources().getString(R.string.assets_selected), event.getSelectionCount(), mPhotoContentViewAdapter.getItemCount());
            mPhotosSelectedTextView.setText(text);
            mSelectedPhotosUri = event.getSelectedPhotosUri();
        } else {
            String text = String.format(getResources().getString(R.string.assets_selected), event.getSelectionCount(), mVideoContentViewAdapter.getItemCount());
            mVideosSelectedTextView.setText(text);
            mSelectedItemsVideo = event.getSelectedItemsVideo();
        }
    };
}
