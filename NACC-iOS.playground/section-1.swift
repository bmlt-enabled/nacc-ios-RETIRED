import Foundation

extension Int
{
    func format ( f:String ) -> String
    {
        return NSString ( format:"%\(f)d", self )
    }
}

func doSomethingWithAFile ( inFileName:String )
{
    let filename = inFileName
    println ( "The file name is '\(filename)'" )
}

let aBasicIntegerValue:Int = 3
let fileNamePrefix:String = "IMG_"
let fileNameSuffix:String = ".JPG"

for index in 0..100
{
    let fileName = fileNamePrefix + index.format ( "04" ) + fileNameSuffix
    doSomethingWithAFile ( fileName )
}
