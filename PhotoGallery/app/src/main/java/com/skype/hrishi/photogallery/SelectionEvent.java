package com.skype.hrishi.photogallery;

import android.net.Uri;

import java.util.List;

/**
 * Created by hrishi on 10/26/17.
 */

public class SelectionEvent {
    private final int selectionCount;
    private final int assetType;
    private final List<Uri> selectedPhotosUri;
    private final List<Long> selectedItemsVideo;

    public SelectionEvent(int selectionCount, int type, List<Uri> selectedPhotos, List<Long> selectedVideos) {
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

    public List<Uri> getSelectedPhotosUri() {
        return selectedPhotosUri;
    }

    public List<Long> getSelectedItemsVideo() {
        return selectedItemsVideo;
    }
}
