function varargout = saw(varargin)
% SAW MATLAB code for saw.fig
%      SAW, by itself, creates a new SAW or raises the existing
%      singleton*.
%
%      H = SAW returns the handle to a new SAW or the handle to
%      the existing singleton*.
%
%      SAW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAW.M with the given input arguments.
%
%      SAW('Property','Value',...) creates a new SAW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before saw_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to saw_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help saw

% Last Modified by GUIDE v2.5 26-Jun-2021 04:19:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @saw_OpeningFcn, ...
                   'gui_OutputFcn',  @saw_OutputFcn, ...
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


% --- Executes just before saw is made visible.
function saw_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to saw (see VARARGIN)

% Choose default command line output for saw
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes saw wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = saw_OutputFcn(hObject, eventdata, handles) 
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
% import data dari datarumah.xlsx kolom 1
opts = detectImportOptions('datarumah.xlsx');
opts.SelectedVariableNames = (1);
data1 = readmatrix('datarumah.xlsx',opts);

% import data dari datarumah.xlsx  kolom 3 sampai 8
opts = detectImportOptions('datarumah.xlsx');
opts.SelectedVariableNames = (3:8);
data2 = readmatrix('datarumah.xlsx',opts);

% proses penggabungan import data & penampilan ke dalam uitable1
data = [data1 data2];
set(handles.uitable1,'data',data);
opts = detectImportOptions('datarumah.xlsx');
opts.SelectedVariableNames = (3:8);

% membaca isi dalam datarumah.xlsx
data = readmatrix('datarumah.xlsx',opts);

% nilai bobot tiap kriteria seperti dalam soal
% yang bila ditotalkan jumlahnya = 1
nilaiC1 = 0.30;
nilaiC2 = 0.20;
nilaiC3 = 0.23;
nilaiC4 = 0.10;
nilaiC5 = 0.07;
nilaiC6 = 0.10;
w = [nilaiC1 nilaiC2 nilaiC3 nilaiC4 nilaiC5 nilaiC6];

%atribut masing-masing kriteria disesuaikan
%atribut jika 1 maka dimaksimalkan (menguntungkan) 
%jika 0 maka diminimalkan (biaya)
atributC1 = 0;
atributC2 = 1;
atributC3 = 1;
atributC4 = 1;
atributC5 = 1;
atributC6 = 1;
k = [atributC1 atributC2 atributC3 atributC4 atributC5 atributC6];

% tahapan pertama, memperbaiki bobot
[m,n]=size(data); 
    R=zeros(m,n);
    
% tahapan kedua, melakukan perhitungan vektor(S) per baris (alternatif)    
for j=1:n
    if k(j)==1
        %menghitung normalisasi kriteria jenis benefit
        R(:,j)=data(:,j)./max(data(:,j));
 gui   else
        %menghitung normalisasi kriteria jenis cost
        R(:,j)=min(data(:,j))./data(:,j);
    end
end

for i=1:m
    V(i)= sum(w.*R(i,:));
end

%   tahapan ketiga, proses perangkingan & menampilkannya kedalam uitable2
Vtranspose=V.'; 
Vtranspose=num2cell(Vtranspose);
opts = detectImportOptions('datarumah.xlsx');
opts.SelectedVariableNames = (2);
data2= readtable('datarumah.xlsx',opts);
data2 = table2cell(data2);
data2=[data2 Vtranspose];
data2=sortrows(data2,-2);
% mengambil 20 alternatif teratas
data2 = data2(1:20,1);
set(handles.uitable2, 'data', data2);
