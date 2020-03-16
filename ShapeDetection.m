function[imageProcessed]=ShapeDetection(initialIMG,num)

%if num is equal to 1 then PreProcess function is called,otherwise
%DetectShapes function is called
    if(num==1)
        imageProcessed = PreProcess(initialIMG);
    elseif num==2
        imageProcessed = DetectShapes(initialIMG);
    end
    
end

%Preprocess function returns an image with black background
%Unnecessary shapes or objects below a certain threshold area are also removes
function[initialIMG]=PreProcess(initialIMG)
%Checks the background color of the image
initilColor = initialIMG(1,1,:);
%if the color of background is not black,set the background color to black,otherwise do nothing
     if initilColor~=0
        for i=1:size(initialIMG,1)
           for j=1:size(initialIMG,2)
               if initialIMG(i,j,:)==initilColor
                    initialIMG(i,j,:) = 0;
               end
           end       
        end
     end
    %Once we have an image with black background,we can get rid of unwanted objects in the image 
    %First convert the image from rbg to gray
    im = rgb2gray(initialIMG);
    %binarize the grayScale Image
    im = im2bw(im);
    %this function detects objects and their number in the image
    [labeledImage,numBlobs] = bwlabel(im);
    for k=1:numBlobs
        %this function returns a object present in the image depending on k
        thisBlob = ismember(labeledImage,k);
        %get area,orientation and BoundingBox Properties for thisBlob image 
        measurement = regionprops(thisBlob,'Centroid','Area','BoundingBox');
        %if the area of the image is below a certain threshold we can set it to black
        if measurement.Area<2000
            x = floor(measurement.BoundingBox(1));
            y = floor(measurement.BoundingBox(2));
            i = floor(measurement.BoundingBox(3));
            j = floor(measurement.BoundingBox(4));
            for l=x:x+i
                for o=y:y+j
                    initialIMG(o,l,:) = 0;
                end
            end
        end

    end
end


function[rgbImageProcessed]=DetectShapes(rgbImageProcessed)

    im = rgb2gray(rgbImageProcessed);
    %binarize the grayScale Image
    im = im2bw(im,0.1);
    %get the center of each object identified in the image
    center = regionprops(im,'Centroid');
    %Label each object in the binarized image and number of objects
    [labeledImage,numBlobs] = bwlabel(im);
    imshow(rgbImageProcessed),
    hold on
    for k=1:numBlobs
    %returns image labeled k
    thisBlob = ismember(labeledImage,k);
    %get orientation and BoundingBox Properties for image k
    measurement = regionprops(thisBlob,'Orientation','BoundingBox');
    %crop the original image read using BoundingBox measurement
    croppedImage = imcrop(rgbImageProcessed,measurement.BoundingBox);
    %Get orientation of image k
    angle = measurement.Orientation;
    %rotate image k by its orientation
    uprightImage = imrotate(croppedImage,angle);
    %--------------------------------
    %convert uprightImage to GrayScale
    GRAY = rgb2gray(uprightImage);
    %Binarize the GrayScale Image
    BW = im2bw(GRAY,0.1);
    %Get properties of the binarize Image
    STATS = regionprops(BW, 'all');
    %-----------------------------------------------------
    %get ratio of length and width of the Image
    if size(STATS,1)>0
        if STATS(1).BoundingBox(3)>STATS(1).BoundingBox(4)
            lenRatio = STATS(1).BoundingBox(4)./STATS(1).BoundingBox(3);
        else
            lenRatio = STATS(1).BoundingBox(3)./STATS(1).BoundingBox(4);
        end

        %-----------------------------------------------------
        %If lenRation >0.95 then W =1
        W = uint8(lenRatio > 0.95);
        %if 1-STATS.Extent<0.1 then W = W + 2
        W = W + 2 * uint8((1-(STATS(1).Extent)) < 0.1 );
        %get center axis of object k
        centroid = center(k).Centroid;
        %Extent returns ratio of object to boundingBox
        extent = STATS(1).Extent;
           %if extent between 0.77-0.79,then a circle
           if and(extent>0.77,extent<0.79)
                plot(centroid(1),centroid(2),'wO');
           elseif W==2
               %if W==2,then shape is rectangle
                plot(centroid(1),centroid(2),'wS');
                plot(centroid(1),centroid(2),'wX');
           elseif W==3
               %if W==3,then shape is square
                plot(centroid(1),centroid(2),'wS');
           elseif and(extent>0.25,extent<0.60)
                %if extent between 0.25-0.6,then shape is triangle
                plot(centroid(1),centroid(2),'wX');
           end

    end
    end

end