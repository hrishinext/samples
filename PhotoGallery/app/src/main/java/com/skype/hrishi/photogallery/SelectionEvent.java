package com.skype.hrishi.photogallery;

import android.net.Uri;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by hrishi on 10/26/17.
 */

public class SelectionEvent {
    private final int selectionCount;
    private final int assetType;
    private final ArrayList<String> selectedPhotosUri;
    private final ArrayList<String> selectedItemsVideo;

    public SelectionEvent(int selectionCount, int type, ArrayList<String> selectedPhotos, ArrayList<String> selectedVideos) {
        this.selectionCount = selectionCount;
        this.assetType = type;
        this.selectedPhotosUri = selectedPhotos;
        this.selectedItemsVideo = selectedVideos;
    }

    public int getSelectionCount() {
        return selectionCount;
    }

    public int getAssetType() {
        return assetType;
    }

    public ArrayList<String> getSelectedPhotosUri() {
        return selectedPhotosUri;
    }

    public ArrayList<String> getSelectedItemsVideo() {
        return selectedItemsVideo;
    }
}
