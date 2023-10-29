function varargout = batu(varargin)
% BATU MATLAB code for batu.fig
%      BATU, by itself, creates a new BATU or raises the existing
%      singleton*.
%
%      H = BATU returns the handle to a new BATU or the handle to
%      the existing singleton*.
%
%      BATU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BATU.M with the given input arguments.
%
%      BATU('Property','Value',...) creates a new BATU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before batu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to batu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help batu

% Last Modified by GUIDE v2.5 26-Jul-2022 10:10:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @batu_OpeningFcn, ...
                   'gui_OutputFcn',  @batu_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before batu is made visible.
function batu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to batu (see VARARGIN)

% Choose default command line output for batu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
movegui(hObject,'center');

% UIWAIT makes batu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = batu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%menampilkan menu browse image
[nama_file, nama_folder] = uigetfile('*.jpg');

% jika ada nama file yang dipilih maka akan mengeksekusi perintah dibawah
% ini
if ~isequal(nama_file,0)
    Img = imread(fullfile(nama_folder,nama_file));
    axes(handles.axes1)
    imshow(Img);
    title('Original Image')
    handles.Img = Img;
    guidata(hObject, handles)
else
    return
end

red = mean(mean(Img(:,:,1)));
green = mean(mean(Img(:,:,2)));
blue = mean(mean(Img(:,:,3)));

set(handles.edit1,'String',red);
set(handles.edit2,'String',green);
set(handles.edit3,'String',blue);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Img = handles.Img;

Img_gray = rgb2gray(Img);
axes(handles.axes11)
imshow(Img_gray)
title('Grayscale')
 
axes(handles.axes12)
imhist(Img_gray)
title('Histogram')
grid on

 %melakukan konversi citra grayscale ke biner
    bw = imbinarize(Img_gray);
%     figure, imshow(bw)
    %melkukan operasi komplemen
    bw = imcomplement(bw);
%     figure, imshow(bw)
    %melakukan operasi morfologi filing holes
    bw = imfill(bw,'holes');
handles.bw = bw;
handles.Img_gray = Img_gray;
guidata(hObject, handles)

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Img_gray = handles.Img_gray;
Img_stretch = imadjust(Img_gray);
 
axes(handles.axes13)
imshow(Img_stretch)
title('Contrast Strecthing')
 
axes(handles.axes14)
imhist(Img_stretch)
title('Histogram')
grid on

handles.Img_stretch = Img_stretch;
handles.Img_gray = Img_stretch;
guidata(hObject, handles)
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 Img = handles.Img;

bw = handles.bw;
%ekstrasi ciri
    %melakukan konversi citra rgb ke hsv
    HSV = rgb2hsv(Img);
    axes(handles.axes15)
    imshow(HSV)
  
    %melakukan ekstrasi komponen h,s &v pada citra hsv
    H = HSV(:,:,1);
    S = HSV(:,:,2);
    V = HSV(:,:,3);
    %mengubah nilai pixel bg menjadi 0
    H(~bw)=0;
    S(~bw)=0;
    V(~bw)=0;
    %menghitung nilai rata" h,s,v
    Hue = sum(sum(H))/sum(sum(bw));
    Saturation = sum(sum(S))/sum(sum(bw));
    Value = sum(sum(V))/sum(sum(bw));
    %menghitung luas objek
    Luas = sum(sum(bw));
    %mengisi variable ciri latih dengan ciri hasil ekstrasi
    ciri_uji(1,1)= Hue;
    ciri_uji(1,2)= Saturation;
    ciri_uji(1,3)= Value;
    ciri_uji(1,4)= Luas;
    
%     %menampilkan nilai HSV
H = Hue;
S = Saturation;
V = Value;

set(handles.edit10,'String',H);
set(handles.edit11,'String',S);
set(handles.edit12,'String',V);

handles.ciri_uji = ciri_uji;
guidata(hObject, handles)
   

% --- Executes on button press in pushbutton6.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ciri_uji = handles.ciri_uji;
%memanggil naive bayes hasil pelatihan
load Mdl

%membaca kelas keluaran hasil pengujian
hasil_uji = predict(Mdl,ciri_uji);

set(handles.edit5,'string',hasil_uji(1));

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Img_stretch = handles.Img_gray;

pixel_dist = str2double(get(handles.edit6,'String'));
GLCM = graycomatrix(Img_stretch,'Offset',[0 pixel_dist; -pixel_dist pixel_dist; -pixel_dist 0; -pixel_dist -pixel_dist]);
stats = graycoprops(GLCM,{'Contrast','Correlation','Energy','Homogeneity'});
 
Contrast = stats.Contrast;
Correlation = stats.Correlation;
Energy = stats.Energy;
Homogeneity = stats.Homogeneity;
 
data = get(handles.uitable1,'Data');
data{1,1} = num2str(Contrast(1));
data{1,2} = num2str(Contrast(2));
data{1,3} = num2str(Contrast(3));
data{1,4} = num2str(Contrast(4));
data{1,5} = num2str(mean(Contrast));
 
data{2,1} = num2str(Correlation(1));
data{2,2} = num2str(Correlation(2));
data{2,3} = num2str(Correlation(3));
data{2,4} = num2str(Correlation(4));
data{2,5} = num2str(mean(Correlation));
 
data{3,1} = num2str(Energy(1));
data{3,2} = num2str(Energy(2));
data{3,3} = num2str(Energy(3));
data{3,4} = num2str(Energy(4));
data{3,5} = num2str(mean(Energy));
 
data{4,1} = num2str(Homogeneity(1));
data{4,2} = num2str(Homogeneity(2));
data{4,3} = num2str(Homogeneity(3));
data{4,4} = num2str(Homogeneity(4));
data{4,5} = num2str(mean(Homogeneity));
 
set(handles.uitable1,'Data',data,'ForegroundColor',[0 0 0])

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
 
axes(handles.axes11)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
 
axes(handles.axes12)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
 
axes(handles.axes13)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
 
axes(handles.axes14)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes15)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
 
set(handles.edit1,'String',[])
set(handles.edit2,'String',[])
set(handles.edit3,'String',[])
set(handles.edit5,'String',[])
set(handles.edit10,'String',[])
set(handles.edit11,'String',[])
set(handles.edit12,'String',[])
set(handles.uitable1,'Data',[],'RowName',{'' '' '' ''})

function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
