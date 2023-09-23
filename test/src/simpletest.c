#include <windows.h>
 
int APIENTRY WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
    LPSTR lpCmdLine, int nCmdShow)
{
  MessageBoxW(NULL,
    L"Everything is working !",
    L"Hello World", MB_OK);
  return 0;
}