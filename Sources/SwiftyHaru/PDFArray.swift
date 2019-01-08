//
//  PDFArray.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 08/01/2019.
//

#if SWIFT_PACKAGE
import CLibHaru
#endif

internal final class PDFArray: Collection {

    let handle: HPDF_Array

    /// Creates a `PDFArray` from its LibHaru handle. Doesn't take the ownership of the handle.
    init(handle: HPDF_Array) {
        self.handle = handle
    }

    // TODO: In the future we need to create the PDFObject class and use it here.
    typealias Element = UnsafeMutableRawPointer?

    var startIndex: Int {
        return 0
    }

    var endIndex: Int {
        return Int(HPDF_Array_Items(handle))
    }

    subscript(position: Int) -> UnsafeMutableRawPointer? {

        // Reimplementation of HPDF_Array_GetItem that doesn't require specifying an object class

        guard var obj = HPDF_List_ItemAt(handle.pointee.list, HPDF_UINT(position)) else {
            HPDF_SetError(handle.pointee.error, HPDF_STATUS(HPDF_ARRAY_ITEM_NOT_FOUND), 0)
            return nil
        }

        let header = obj.assumingMemoryBound(to: _HPDF_Obj_Header.self)

        if header.pointee.obj_class == HPDF_OCLASS_PROXY {
            obj = obj.assumingMemoryBound(to: _HPDF_Proxy_Rec.self).pointee.obj
        }

        return obj
    }

    func index(after i: Int) -> Int {
        return i + 1
    }

    subscript(position: Int) -> HPDF_Real? {

        guard let object = self[position] as UnsafeMutableRawPointer? else { return nil }

        guard PDFArray._objClass(of: object, is: HPDF_UINT16(HPDF_OCLASS_REAL)) else {
            HPDF_SetError(handle.pointee.error, HPDF_STATUS(HPDF_ARRAY_ITEM_UNEXPECTED_TYPE), 0)
            return nil
        }

        return object.assumingMemoryBound(to: _HPDF_Real_Rec.self)
    }

    // TODO: This should not be there, need to refactor it somewhere else
    private static func _objClass(of obj: UnsafeMutableRawPointer, is objClass: HPDF_UINT16) -> Bool {
        let header = obj.assumingMemoryBound(to: _HPDF_Obj_Header.self)
        return (header.pointee.obj_class & HPDF_UINT16(HPDF_OCLASS_ANY)) == objClass
    }
}
