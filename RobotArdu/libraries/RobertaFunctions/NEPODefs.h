#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

#ifndef M_E
#define M_E 2.718281828459045
#endif

#ifndef M_GOLDEN_RATIO
#define M_GOLDEN_RATIO 1.61803398875
#endif

#ifndef M_SQRT2
#define M_SQRT2 1.41421356237
#endif

#ifndef M_SQRT1_2
#define M_SQRT1_2 0.707106781187
#endif

#ifndef M_INFINITY
#define M_INFINITY 0x7f800000
#endif

#ifndef RCHANNEL
#define RCHANNEL(color) ((uint8_t)(color >> 16))
#endif

#ifndef GCHANNEL
#define GCHANNEL(color) ((uint8_t)(color >> 8))
#endif

#ifndef BCHANNEL
#define BCHANNEL(color) ((uint8_t)(color))
#endif

#ifndef _ARDUINO_STL_NOT_NEEDED
#include <ArduinoSTL.h>
#endif

#include <list>
#include <math.h>
#include <vector>

#ifndef _BOB3_INCLUDES
inline uint32_t RGB(uint8_t r, uint8_t g, uint8_t b) {
    return (((uint32_t)(r)) << 16) | (((uint32_t)(g)) << 8) | ((uint32_t)(b));
}
#else
inline unsigned RGB(unsigned r, unsigned g, unsigned b) {
    return ((r & 0xF0) << 4) | (g & 0xF0) | ((b & 0xF0) >> 4);
}
#endif

inline int get_microphone_volume(int microphone_port) {
    int min = 1023;
    int max = 0;
    int value = 0;
    for (int i = 0; i < 32; i += 1) {
        value = analogRead(microphone_port);
        if ( value > max ) {
            max = value;
        } else if ( value < min ) {
            min = value;
        }
    }
    return (( max - min ) * 0.0977);
}


//inline unsigned RGB(unsigned r, unsigned g, unsigned b) {
//    return (((r & 0xF8) << 8) | ((g & 0xFC) << 3) | ((b & 0xF8) >> 3));
//}

inline double absD(double d) {
    return d < 0.0 ? -d : d;
}

inline bool isWholeD(double d) {
    return d == floor(d);
}

inline bool isPrimeD(double d) {
    if (!isWholeD(d)) {
        return false;
    }
    int n = (int) d;
    if (n < 2) {
        return false;
    }
    if (n == 2) {
        return true;
    }
    if (n % 2 == 0) {
        return false;
    }
    for (int i = 3, s = (int) (sqrt(d) + 1); i <= s; i += 2) {
        if (n % i == 0) {
            return false;
        }
    }
    return true;
}

inline int _randomIntegerInRange(int val1, int val2) {
    int min = fmin(val1, val2);
    int max = fmax(val1, val2) + 1;
    return min + (rand() % (min - max));
}

inline float _randomFloat() {
    return (float) rand() / (float) RAND_MAX;
}

template<typename T>
std::list<T> &_createListRepeat(unsigned count, T e) {
    std::list<T> &l = *(new std::list<T>);
    for (unsigned i = 0; i < count; i++) {
        l.push_back(e);
    }
    return l;
}

template<typename T>
T _getListElementByIndex(std::list<T> &list, unsigned index) {
    auto iterator = list.begin();
    advance(iterator, index);
    return (*iterator);
}

template<typename T>
T _getListElementByIndex(const std::list<T> &list, unsigned index) {
    _getListElementByIndex(list, index);
}

template<typename T>
T _getAndRemoveListElementByIndex(std::list<T> &list, unsigned index) {
    auto iterator = list.begin();
    advance(iterator, index);
    T value = (*iterator);
    list.erase(iterator);
    return value;
}

template<typename T>
void _removeListElementByIndex(std::list<T> &list, unsigned index) {
    _getAndRemoveListElementByIndex(list, index);
}

/*
 * The only known situation where the cast of P to T would be needed is for int to double
 * in other cases T and P will be the same type. If only one template parameter is used
 * then the match void setListElementByIndex(std::list<double>, int, int) would not be possible
 */

template<typename T, typename P>
void _setListElementByIndex(std::list<T> &list, unsigned index, P value) {
    if (index < list.size()) {
        auto iterator = list.begin();
        advance(iterator, index);
        (*iterator) = (T) (value);
    } else {
        list.push_back((T) (value));
    }
}

template<typename T, typename P>
void _insertListElementBeforeIndex(std::list<T> &list, unsigned index,
        P value) {
    auto iterator = list.begin();
    advance(iterator, index);
    list.insert(iterator, (T) (value));
}

template<typename T, typename P>
int _getFirstOccuranceOfElement(std::list<T> &list, P value) {
    int i = 0;
    auto iterator = list.begin();
    for (i = 0, iterator = list.begin(); iterator != list.end();
            ++iterator, ++i) {
        if ((P) (*iterator) == value) {
            return i;
        }
    }
    return -1;
}

template<typename T, typename P>
int _getLastOccuranceOfElement(std::list<T> &list, P value) {
    int i = 0;
    auto iterator = list.rbegin();
    for (i = 0, iterator = list.rbegin(); iterator != list.rend();
            ++iterator, ++i) {
        if ((P) (*iterator) == value) {
            return list.size() - i - 1;
        }
    }
    return -1;
}

template<typename T>
std::list<T> &_getSubList(std::list<T> &list, int startIndex, int endIndex) {
    auto beginIterator = list.begin();
    advance(beginIterator, startIndex);
    auto endIterator = list.begin();
    advance(endIterator, endIndex + 1);
    return *(new std::list<T>(beginIterator, endIterator));
}

double _getListSum(std::list<double> &list) {
    double result = 0;
    for (auto iterator = list.begin(); iterator != list.end(); ++iterator) {
        result += *iterator;
    }
    return result;
}

double _getListMin(std::list<double> &list) {
    double result = *(list.begin());
    for (auto iterator = list.begin(); iterator != list.end(); ++iterator) {
        if (result > *iterator) {
            result = *iterator;
        }
    }
    return result;
}

double _getListMax(std::list<double> &list) {
    double result = *(list.begin());
    for (auto iterator = list.begin(); iterator != list.end(); ++iterator) {
        if (result < *iterator) {
            result = *iterator;
        }
    }
    return result;
}

double _getListMedian(std::list<double> &list) {
    std::list<double> sorted(list);
    sorted.sort();
    auto iterator = sorted.begin();
    if (sorted.size() % 2 == 0) {
        for (unsigned int i = 0; i < sorted.size() / 2; i++) {
            iterator++;
        }
        return (*iterator + *--iterator) / 2;
    } else {
        for (unsigned int i = 0; i < sorted.size() / 2; i++) {
            iterator++;
        }
        return *iterator;
    }
}

double _getListAverage(std::list<double> &list) {
    double sum = _getListSum(list);
    return sum / list.size();
}

double _getListStandardDeviation(std::list<double> &list) {
    double mean = _getListSum(list) / list.size();
    double sum = 0;
    for (auto iterator = list.begin(); iterator != list.end(); ++iterator) {
        sum += (*iterator - mean) * (*iterator - mean);
    }
    sum /= list.size() - 1;
    return sqrt(sum);
}

template<typename T, typename U>
void assertNepo(bool test, String text, T left, String op, U right) {
    if (!test) {
        Serial.println(
                "Assertion failed: " + text + " " + left + " " + op + " "
                        + right);
        Serial.flush();
    }
}

template<typename T, typename U>
void _printToDisplay(T &disp, U input, bool isOled=false) {
    disp.print(input);
    if (isOled) {
        disp.display();
    }
}

template<typename T, typename U>
void _printToDisplay(T &disp, std::list<U, std::allocator<U>> input, bool isOled=false) {
    for (auto i : input) {
        _printToDisplay(disp, i, isOled);
        delay(50);
    }
}

#ifdef MeMCore_H
std::vector<uint8_t> invertLEDMatrixVec(std::vector<uint8_t> arr) { 
    for (uint8_t i = 0; i < 16; i++) { 
        arr[i]=~(byte)arr[i];
    }  
    return arr;
}

std::vector<uint8_t> shiftLEDMatrixRightVec(std::vector<uint8_t> arr, int shift) {
    if (shift > 0) {
        arr.insert(arr.begin(), shift, 0);
        arr.erase(arr.end(), arr.end() - shift);
    } else if (shift < 0) {
        arr.erase(arr.begin(), arr.begin() - shift);
        arr.insert(arr.end(), -shift, 0);
    }
    return arr;
}

std::vector<uint8_t> shiftLEDMatrixLeftVec(std::vector<uint8_t> arr, int shift) {
    if (shift < 0) {
        arr.erase(arr.begin(), arr.begin() - shift);
        arr.insert(arr.end(), -shift, 0);
    } else if (shift > 0) {
        arr.erase(arr.begin(), arr.begin() + shift);
        arr.insert(arr.end(), shift, 0);      
    }
    return arr;
}
std::vector<uint8_t> shiftLEDMatrixLeftArr( uint8_t arr[16], int shift) {
    std::vector<uint8_t> myvec(arr, arr + 16);
    return shiftLEDMatrixLeftVec(myvec, shift);
}

std::vector<uint8_t> shiftLEDMatrixUpVec(std::vector<uint8_t> arr, int shift) {
    if (shift > 0) {
        for (uint8_t i = 0; i < 16; i++) { 
            arr[i]=(byte)arr[i] << shift;
        } 
    } else if (shift < 0) {
        for (uint8_t i = 0; i < 16; i++) { 
            arr[i]=(byte)arr[i] >> -shift;
        } 
    }
    return arr;
}

std::vector<uint8_t> shiftLEDMatrixDownVec(std::vector<uint8_t> arr, int shift) {
    if (shift < 0) {
        for (uint8_t i = 0; i < 16; i++) { 
            arr[i]=(byte)arr[i] << -shift;
        } 
    } else if (shift > 0) {
        for (uint8_t i = 0; i < 16; i++) { 
            arr[i]=(byte)arr[i] >> shift;
        } 
    }
    return arr;
}

void drawStrLEDMatrix(MeLEDMatrix *meLEDMatrix, const String &str, int tmp ) {
    meLEDMatrix->drawStr(0, 7, str.c_str());
    delay(tmp * 3);
    int size = (str.length() * 6) - 16;
    for (int i = -1; i >= -size; i--) {
        meLEDMatrix->drawStr(i, 7, str.c_str());
        delay(tmp);
    }
}

void drawAnimationLEDMatrix(MeLEDMatrix *meLEDMatrix, std::list<std::vector<uint8_t>> &arr, int tmp ) {
    for (std::list<std::vector<uint8_t>>::iterator it = arr.begin(); it != arr.end(); ++it){
        meLEDMatrix->drawBitmap(0, 0, 16, &(*it)[0]);
        delay(tmp);
    }
}
#endif // MeMCore_H

