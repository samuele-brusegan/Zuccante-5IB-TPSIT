void main(){
  print(isEven(2));
  print(isEven(3));
  print(isEven(4));
  print(isEven(5));
}

/// Returns TRUE for even FALSE for odd
bool isEven(int n){
  if (n % 2 == 0) return true;
  else return false;
}
