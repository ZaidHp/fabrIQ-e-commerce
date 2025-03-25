import React, { useState, useEffect } from "react";
import { FaCamera, FaTrash } from "react-icons/fa";
import { useLocation } from "react-router-dom"; //, useParams
import { useNavigate } from "react-router-dom";
import { toast } from 'react-toastify';
import Swal from 'sweetalert2';

const NewProduct = () => {
  const location = useLocation();
  const productFromState = location.state?.product;
  const [existingProduct, setExistingProduct] = useState(productFromState || null);
  const [isLoading, setIsLoading] = useState(true);

  const [product_name, setName] = useState("");
  const [sku, setSku] = useState("");
  const [product_price, setPrice] = useState("");
  const [weight, setWeight] = useState("");
  const [product_description, setDescription] = useState("");
  const [url_key, setUrlKey] = useState("");

  const [product_status, setStatus] = useState("disabled");
  const [product_visibility, setVisibility] = useState("not_visible");
  const [manage_stock, setManageStock] = useState("No");
  const [stock_available, setStockAvailable] = useState("No");
  const [product_quantity, setQuantity] = useState(0);

  const [color, setColor] = useState("");
  const [size, setSize] = useState("");
  const [images, setImages] = useState([]);
  const [removedImageUrls, setRemovedImageUrls] = useState([]);
  const [loading, setLoading] = useState(false);


  useEffect(() => {
    const searchParams = new URLSearchParams(location.search);
    const productId = searchParams.get("id");

    if (!productFromState && productId) {
      fetch(`http://localhost:8080/api/products/${productId}`)
        .then((res) => res.json())
        .then((data) => {
          if (data) {
            setExistingProduct(data);
          }
          setIsLoading(false);
        })
        .catch((err) => {
          console.error("Error fetching product:", err);
          setIsLoading(false);
        });
    } else {
      setIsLoading(false);
    }
  }, [productFromState, location.search]);

  useEffect(() => {
    if (existingProduct) {
      setName(existingProduct.product_name || "");
      setSku(existingProduct.sku || "");
      setPrice(existingProduct.product_price || "");
      setWeight(existingProduct.weight || "");
      setDescription(existingProduct.product_description || "");
      setUrlKey(existingProduct.url_key || "");
      setStatus(existingProduct.product_status || "disabled");
      setVisibility(existingProduct.product_visibility || "not_visible");
      setManageStock(existingProduct.manage_stock || "No");
      setStockAvailable(existingProduct.stock_availability || "No");
      setQuantity(existingProduct.product_quantity || 0);
      setColor(existingProduct.color || "");
      setSize(existingProduct.size || "");

      const BACKEND_URL = "http://localhost:8080"; // or from env

      if (existingProduct.images && Array.isArray(existingProduct.images)) {
        const formatted = existingProduct.images.map((imgUrl) => ({
        file: null,
        preview: imgUrl.startsWith("http") ? imgUrl : `${BACKEND_URL}${imgUrl}`,
      }));
      setImages(formatted);
      }
    }
  }, [existingProduct]);

  const handleImageChange = (e) => {
    const files = Array.from(e.target.files);
    const newImages = files.map((file) => ({
      file,
      preview: URL.createObjectURL(file),
    }));
    setImages((prev) => [...prev, ...newImages]);
  };

  const handleRemoveImage = (index) => {
    setImages((prev) => {
      const updated = [...prev];
      const removed = updated.splice(index, 1)[0];
      if (!removed.file && removed.preview) {
        setRemovedImageUrls((prevUrls) => [...prevUrls, removed.preview]);
      }
      return updated;
    });
  };

  const handleSave = async () => {
    const formData = new FormData();
    const business_id = localStorage.getItem("business_id");
    const category_id = "1"; // TODO: make this dynamic later
    
    if (!business_id) {
      alert("Business ID not found. Please login again.");
      return;
    }

    const missingFields = [];
    if (!sku) missingFields.push("SKU");
    if (!product_name) missingFields.push("Name");
    if (!product_description) missingFields.push("Description");
    if (!product_price) missingFields.push("Price");
    if (!weight) missingFields.push("Weight");
    if (!product_quantity && product_quantity !== 0) missingFields.push("Quantity");
    if (!manage_stock) missingFields.push("Manage Stock");
    if (!stock_available) missingFields.push("Stock Availability");
    if (!product_status) missingFields.push("Status");
    if (!product_visibility) missingFields.push("Visibility");
    if (!url_key) missingFields.push("URL Key");
    if (!color) missingFields.push("Color");
    if (!size) missingFields.push("Size");


    if (missingFields.length > 0) {
      toast.error(`Please fill in: ${missingFields.join(", ")}`);
      return;
    }


    formData.append("business_id", business_id);
    formData.append("category_id", category_id);
    formData.append("sku", sku);
    formData.append("product_name", product_name);
    formData.append("product_description", product_description);
    formData.append("product_price", product_price);
    formData.append("weight", weight);
    formData.append("product_quantity", product_quantity);
    formData.append("manage_stock", manage_stock);
    formData.append("stock_availability", stock_available);
    formData.append("product_status", product_status);
    formData.append("product_visibility", product_visibility);
    formData.append("url_key", url_key);
    formData.append("color", color);
    formData.append("size", size);

    if (removedImageUrls.length > 0) {
      formData.append("removedImages", JSON.stringify(removedImageUrls));
    }

    images.forEach((img) => {
      if (img.file) {
        formData.append("images", img.file);
      }
    });
    setLoading(true);
    try {
      const isEditing = !!existingProduct;
      const productId = isEditing ? existingProduct.product_id : null;

      if (isEditing && !productId) {
        alert("Missing product ID for update!");
        return;
      }
      const response = await fetch(
        existingProduct
          ? `http://localhost:8080/api/products/${productId}`
          : "http://localhost:8080/api/products",
        {
          method: existingProduct ? "PUT" : "POST",
          body: formData,
        }
      );

      if (response.ok) {
        toast.success(existingProduct ? "Product updated successfully!" : "Product created successfully!");
        setName("");
        setSku("");
        setPrice("");
        setWeight("");
        setDescription("");
        setUrlKey("");
        setStatus("disabled");
        setVisibility("not_visible");
        setManageStock("No");
        setStockAvailable("No");
        setQuantity(0);
        setColor("");
        setSize("");
        setImages([]);
        setExistingProduct(null);
      } else {
        const errorData = await response.json();
        console.error("Server error:", errorData);
        toast.error("Failed to save product.");
      }
    } catch (error) {
      console.error("Error saving product:", error);
      toast.error("An error occurred while saving.");
    }finally {
      setLoading(false);
    }
  };

  const navigate = useNavigate();

  const resetForm = () => {
    setName("");
    setSku("");
    setPrice("");
    setWeight("");
    setDescription("");
    setUrlKey("");
    setStatus("disabled");
    setVisibility("not_visible");
    setManageStock("No");
    setStockAvailable("No");
    setQuantity(0);
    setColor("");
    setSize("");
    setImages([]);
    setExistingProduct(null);
    setRemovedImageUrls([]);
  };

  const handleCancel = async () => {
    const result = await Swal.fire({
      title: 'Are you sure?',
      text: 'All unsaved changes will be lost.',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Yes, cancel',
      cancelButtonText: 'No, stay',
      confirmButtonColor: '#d33',
      cancelButtonColor: '#3085d6',
    });
  
    if (result.isConfirmed) {
      if (existingProduct) {
        toast.info("Canceled. Returning to product list.");
        navigate("/products");
      } else {
        resetForm();
        toast.info("Form cleared.");
      }
    }
  };


  if (isLoading) {
    return <div className="ml-[220px] p-6">Loading product data...</div>;
  }

  return (
    <div className="flex justify-between ml-[220px] w-[calc(%-0px)] bg-black min-h-screen">
      <div className="flex justify-between p-6 ml-[0px] w-[calc(300%-0px)] bg-gray-100 min-h-screen">
        <div className="w-2/3 bg-white shadow-lg rounded-lg p-6">
          <h2 className="text-2xl font-semibold mb-4 text-left block">Create a new product</h2>
          <div className="bg-gray-100 p-4 rounded-lg">
            <label className="text-lg font-medium mb-3 text-left block">General</label>
            <label className="text-lg font-medium mb-3 text-left block mt-4">Name</label>
            <input type="text" value={product_name} onChange={(e) => setName(e.target.value)} placeholder="Name" className="w-full p-2 border mb-2 rounded" />

            <div className="grid grid-cols-3 gap-4">
              <label className="text-lg font-medium mb-3 text-left block">SKU</label>
              <label className="text-lg font-medium mb-3 text-left block">Price</label>
              <label className="text-lg font-medium mb-3 text-left block">Weight</label>
            </div>

            <div className="grid grid-cols-3 gap-4">
              <input type="text" value={sku} onChange={(e) => setSku(e.target.value)} placeholder="SKU" className="p-2 border rounded" />
              <input type="number" value={product_price} onChange={(e) => setPrice(e.target.value)} placeholder="Price (USD)" className="p-2 border rounded" />
              <input type="number" value={weight} onChange={(e) => setWeight(e.target.value)} placeholder="Weight (kg)" className="p-2 border rounded" />
            </div>

            <label className="text-lg font-medium mb-3 text-left block">Category</label>
            <a href="#" className="text-blue-500 block  text-left">Select category</a>

            <div className="mt-4">
              <label className="text-lg font-medium text-left block mb-2">Description</label>
              <textarea
                value={product_description}
                onChange={(e) => setDescription(e.target.value)}
                className="w-full border border-gray-300 rounded-md p-3 h-24 focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="Write your description here..."
              ></textarea>
            </div>
          </div>

          <br />

          {/* Media Upload */}
          <div className="p-4 border border-gray-200 rounded-lg bg-white shadow-sm mb-4">
            <label className="text-lg font-medium text-left block mb-2">Media</label>
            <div className="flex gap-4 flex-wrap">
              <label className="border-2 border-dashed border-gray-300 rounded-md flex justify-center items-center h-32 w-32 cursor-pointer overflow-hidden relative">
                <FaCamera className="text-teal-600 text-2xl" />
                <input type="file" accept="image/*" multiple onChange={handleImageChange} className="hidden" />
              </label>
              {images.map((img, index) => (
                <div key={index} className="relative h-32 w-32 rounded-md overflow-hidden border">
                  <img src={img.preview} alt={`preview-${index}`} className="object-cover w-full h-full" />
                  <button
                    type="button"
                    onClick={() => handleRemoveImage(index)}
                    className="absolute top-1 right-1 bg-white p-1 rounded-full shadow hover:bg-red-100"
                  >
                    <FaTrash className="text-red-500 text-sm" />
                  </button>
                </div>
              ))}
            </div>
          </div>

          {/* SEO */}
          <div className="p-4 border border-gray-200 rounded-lg bg-white shadow-sm">
            <h2 className="text-lg font-medium text-left block mb-2">Search Engine Optimization</h2>
            <label className="text-left block font-medium mb-1">Url Key</label>
            <input type="url" value={url_key} onChange={(e) => setUrlKey(e.target.value)} className="w-full p-1 border mb-2 rounded" />
          </div>

          <hr className="border-gray-300 mt-6 border-t-4 my-4" />

          <div className="flex justify-between w-full p-4 ">
            <button
              type="button"
              className="text-red-500 px-6 py-2"
              onClick={handleCancel}
            >
              Cancel
            </button>

            <button type="submit" disabled={loading} className="text-green-700 px-6 py-2" onClick={handleSave}>
              {loading ? 'Saving...' : 'Save'}
            </button>
          </div>
        </div>

        {/* Right Panel */}
        <div className="w-1/3 flex flex-col space-y-4 ml-8">
          {/* Product Status */}
          <div className="bg-white p-4 shadow-lg rounded-lg">
            <h2 className="text-lg font-medium mb-3 text-left block">Product Status</h2>
            <h3 className="text-md font-medium mt-3 text-left">Status</h3>
            <label className="text-left block">
              <input className="m-2" type="radio" checked={product_status === "disabled"} onChange={() => setStatus("disabled")} /> Disabled
            </label>
            <label className="text-left block">
              <input className="m-2" type="radio" checked={product_status === "enabled"} onChange={() => setStatus("enabled")} /> Enabled
            </label>

            <hr className="border-gray-300" />

            <h3 className="text-md font-medium mt-3 text-left">Visibility</h3>
            <label className="text-left block">
              <input className="m-2" type="radio" checked={product_visibility === "not_visible"} onChange={() => setVisibility("not_visible")} /> Not Visible
            </label>
            <label className="text-left block">
              <input className="m-2" type="radio" checked={product_visibility === "visible"} onChange={() => setVisibility("visible")} /> Visible
            </label>
          </div>

          {/* Inventory */}
          <div className="bg-white p-4 shadow-lg rounded-lg">
            <h2 className="text-lg font-medium mb-3 text-left block">Inventory</h2>
            <h3 className="text-md font-medium mt-3 text-left">Manage stock?</h3>
            <label className="text-left block">
              <input className="m-2" type="radio" checked={manage_stock === "No"} onChange={() => setManageStock("No")} /> No
            </label>
            <label className="text-left block">
              <input className="m-2" type="radio" checked={manage_stock === "Yes"} onChange={() => setManageStock("Yes")} /> Yes
            </label>

            <hr className="border-gray-300" />

            <h3 className="text-md font-medium mt-3 text-left">Stock availability</h3>
            <label className="text-left block">
              <input className="m-2" type="radio" checked={stock_available === "No"} onChange={() => setStockAvailable("No")} /> No
            </label>
            <label className="text-left block">
              <input className="m-2" type="radio" checked={stock_available === "Yes"} onChange={() => setStockAvailable("Yes")} /> Yes
            </label>

            <hr className="border-gray-300" />
            <label className="text-left block font-medium mb-1 mt-2">Quantity</label>
            <input type="number" value={product_quantity} onChange={(e) => setQuantity(e.target.value)} className="w-full p-1 border mb-1 rounded" />
          </div>

          {/* Attributes */}
          <div className="bg-white p-4 shadow-lg rounded-lg">
            <div className="p-4 border border-gray-200 rounded-lg bg-white shadow-sm mt-2">
              <h2 className="text-lg font-medium mb-3 text-left">ATTRIBUTES</h2>
              <table className="w-full border border-gray-200">
                <tbody>
                  <tr className="border-b">
                    <td className="p-2 font-medium text-gray-700">Color</td>
                    <td className="p-2">
                      <input type="text" value={color} onChange={(e) => setColor(e.target.value)} placeholder="Color" className="p-2 border rounded" />
                    </td>
                  </tr>
                  <tr>
                    <td className="p-2 font-medium text-gray-700">Size</td>
                    <td className="p-2">
                      <select value={size} onChange={(e) => setSize(e.target.value)} className="w-full p-2 border rounded">
                        <option>Please select</option>
                        <option>Small</option>
                        <option>Medium</option>
                        <option>Large</option>
                      </select>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default NewProduct;
