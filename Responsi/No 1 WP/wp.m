function varargout = wp(varargin)
% WP MATLAB code for wp.fig
%      WP, by itself, creates a new WP or raises the existing
%      singleton*.
%
%      H = WP returns the handle to a new WP or the handle to
%      the existing singleton*.
%
%      WP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WP.M with the given input arguments.
%
%      WP('Property','Value',...) creates a new WP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wp

% Last Modified by GUIDE v2.5 26-Jun-2021 01:40:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wp_OpeningFcn, ...
                   'gui_OutputFcn',  @wp_OutputFcn, ...
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


% --- Executes just before wp is made visible.
function wp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wp (see VARARGIN)

% Choose default command line output for wp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes wp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = wp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in showdata.
function showdata_Callback(hObject, eventdata, handles)
% hObject    handle to showdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% import data dari real_estate.xlsx  kolom 3 sampai 5
opts = detectImportOptions('real_estate.xlsx');
opts.SelectedVariableNames = (3:5);
data1 = readmatrix('real_estate.xlsx', opts);

% import data dari real_estate.xlsx  kolom 8
opts = detectImportOptions('real_estate.xlsx');
opts.SelectedVariableNames = (8);
data2 = readmatrix('real_estate', opts);


% proses penggabungan import data & penampilan ke dalam uitable1
% dengan jumlah kolom 1-50
data = [data1 data2];
data = data(1:50,:);
set(handles.uitable1,'data',data);

% --- Executes on button press in cleardata.
function cleardata_Callback(hObject, eventdata, handles)
% hObject    handle to cleardata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitable1, 'data', cell(size(get(handles.uitable1,'data'))));

% --- Executes on button press in kalkulasi.
function kalkulasi_Callback(hObject, eventdata, handles)
% hObject    handle to kalkulasi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ambil data dari table meggunakan
% data = cell2mat(get(handles.uitable1,'data'));
% namun karna eror kita ambil secara manual kembali
opts = detectImportOptions('real_estate.xlsx');
opts.SelectedVariableNames = (3:5);
data1 = readmatrix('real_estate.xlsx', opts);
opts = detectImportOptions('real_estate.xlsx');
opts.SelectedVariableNames = (8);
data2 = readmatrix('real_estate.xlsx', opts);

data = [ data1 data2];
opts = detectImportOptions('real_estate.xlsx');
data = data(1:50,:);

x = data;

% Nilai bobot tiap kriteria (1= sangat buruk, 2=buruk,
% 3=cukup, 4= tinggi, 5= sangat tinggi)
nilaiC1 = 3;
nilaiC2 = 5;
nilaiC3 = 4;
nilaiC4 = 1;
w = [nilaiC1 nilaiC2 nilaiC3 nilaiC4];

% rating kecocokan dari masing-masing alternatif
% atribut jika 1 maka dimaksimalkan (menguntungkan) 
% jika 0 maka diminimalkan (biaya)
atributC1 = 0;
atributC2 = 0;
atributC3 = 1;
atributC4 = 0;
k = [atributC1 atributC2 atributC3 atributC4];

% tahapan pertama, memperbaiki bobot
[m, n]=size (x); 
w=w./sum(w); % membagi bobot per kriteria dengan jumlah total seluruh bobot

% tahapan kedua, melakukan perhitungan vektor(S) per baris (alternatif)
for j=1:n
    if k(j)==0, w(j)=-1*w(j);
    end
end
for i=1:m
    S(i)=prod(x(i,:).^w);
end
V = S/sum(S);

Vtranspose=V.'; 
Vtranspose=num2cell(Vtranspose);
opts = detectImportOptions('real_estate.xlsx');
opts.SelectedVariableNames = (1);
x2 = readmatrix('real_estate.xlsx',opts);
x2 =x2(1:50,:);
x2 =[x2 Vtranspose];
x2 =sortrows(x2,-2);
x2 = x2(1:5,1);
set(handles.uitable2, 'data', x2);





function hasilAlternatif_Callback(hObject, eventdata, handles)
% hObject    handle to hasilAlternatif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hasilAlternatif as text
%        str2double(get(hObject,'String')) returns contents of hasilAlternatif as a double


% --- Executes during object creation, after setting all properties.
function hasilAlternatif_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hasilAlternatif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function hasil2_Callback(hObject, eventdata, handles)
% hObject    handle to hasil2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hasil2 as text
%        str2double(get(hObject,'String')) returns contents of hasil2 as a double


% --- Executes during object creation, after setting all properties.
function hasil2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hasil2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
