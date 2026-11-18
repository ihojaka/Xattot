import UIKit
class KeyboardViewController: UIInputViewController {
 var lang = 0 // 0 Ozbekcha Cyrillic, 1 Ozbekcha Latin, 2 Ozbekche Arabic
 let rowsCyr = [["Й","У","К","Е","Н","Г","Ш","Ў","З","Х"],["Ф","Қ","В","А","П","Р","О","Л","Д","Ж"],["Я","Ч","С","М","И","Т","Ь","Б","Ю"]]
 let rowsLat = [["Q","W","E","R","T","Y","U","I","O","P"],["A","S","D","F","G","H","J","K","L"],["Z","X","C","V","B","N","M"]]
 let rowsAra = [["ض","ص","ث","ق","ف","غ","ع","ه","خ","ح"],["ش","س","ي","ب","ل","ا","ت","ن","م","ک"],["ظ","ط","ذ","د","ز","ر","و","ة","ى"]]
 var shiftOn = false
 override func viewDidLoad(){ super.viewDidLoad(); build() }
 func build(){
  view.subviews.forEach{$0.removeFromSuperview()}
  view.backgroundColor = UIColor(red:0.82,green:0.84,blue:0.87,alpha:1)
  var y: CGFloat = 6
  let rows = lang==0 ? rowsCyr : (lang==1 ? rowsLat : rowsAra)
  for row in rows {
   var x: CGFloat = 4
   let w = (view.bounds.width-8)/CGFloat(row.count) - 4
   for ch in row {
    let b = UIButton(type:.system); b.frame = CGRect(x:x,y:y,width:w,height:44); b.setTitle(shiftOn ? ch.uppercased() : ch, for:.normal); b.backgroundColor = .white; b.layer.cornerRadius=6; b.setTitleColor(.black, for:.normal); b.titleLabel?.font = UIFont.systemFont(ofSize:20); b.addTarget(self, action:#selector(tap(_:)), for:.touchUpInside); view.addSubview(b); x += w+4
   }
   y += 50
  }
  // bottom row 123 | globe | emoji | space | . | return
  let bottomY = y
  func bottomBtn(_ t:String, _ x:CGFloat, _ w:CGFloat, _ act:Selector){ let b=UIButton(type:.system); b.frame=CGRect(x:x,y:bottomY,width:w,height:44); b.setTitle(t,for:.normal); b.backgroundColor = t==" " ? .white : UIColor(red:0.72,green:0.73,blue:0.76,alpha:1); b.layer.cornerRadius=6; b.addTarget(self, action:act, for:.touchUpInside); view.addSubview(b)}
  bottomBtn("123",4,52,#selector(numTap)); bottomBtn("🌐",60,52,#selector(globeTap)); bottomBtn("😊",116,52,#selector(emojiTap))
  let spaceW = view.bounds.width - 116 - 52 - 52 - 52 - 20
  let spaceLabel = lang==0 ? "ЎЗ" : (lang==1 ? "ÖZ" : "اوز")
  bottomBtn(spaceLabel,172,spaceW,#selector(spaceTap))
  bottomBtn(".",172+spaceW+4,48,#selector(dotTap)); bottomBtn("↵",172+spaceW+56,48,#selector(retTap))
  // long-press mapping handled in tap via autocorrect below
 }
 @objc func tap(_ s:UIButton){ var t = s.currentTitle ?? ""
  // New alphabet autocorrect
  if lang==1 {
   // handled in textDidChange via document
  }
  textDocumentProxy.insertText(t)
  // Autocorrect Ch->Ç etc for Latin
  if lang==1 { autocorrectLatin() }
 }
 @objc func spaceTap(){ textDocumentProxy.insertText(" ") }
 @objc func dotTap(){ textDocumentProxy.insertText(".") }
 @objc func retTap(){ textDocumentProxy.insertText("\n") }
 @objc func globeTap(){ lang = (lang+1)%3; build() }
 @objc func emojiTap(){ textDocumentProxy.insertText("😊") }
 @objc func numTap(){ textDocumentProxy.insertText("1") }
 func autocorrectLatin(){
  // Simple: if last 2 chars are Ch/Sh etc, replace - handled via deleteBackward
  // For demo: check document context
  guard let ctx = textDocumentProxy.documentContextBeforeInput else { return }
  if ctx.hasSuffix("Ch") { textDocumentProxy.deleteBackward(); textDocumentProxy.deleteBackward(); textDocumentProxy.insertText("Ç") }
  else if ctx.hasSuffix("Sh") { textDocumentProxy.deleteBackward(); textDocumentProxy.deleteBackward(); textDocumentProxy.insertText("Ş") }
  else if ctx.hasSuffix("O'") { textDocumentProxy.deleteBackward(); textDocumentProxy.deleteBackward(); textDocumentProxy.insertText("Ö") }
  else if ctx.hasSuffix("G'") { textDocumentProxy.deleteBackward(); textDocumentProxy.deleteBackward(); textDocumentProxy.insertText("Ğ") }
  // Abbreviations
  if ctx.hasSuffix("SAS") { for _ in 0..<3 { textDocumentProxy.deleteBackward() }; textDocumentProxy.insertText("ﷺ") }
 }
}
